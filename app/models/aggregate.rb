class Aggregate
  include MongoMapper::Document
  
  key :_id, Hash
  key :key1, Integer
  key :key2, Integer
  key :key3, Integer
  key :sum1, Float
  key :sum2, Float
  key :sum3, Float

  def self.init (collection)
    set_collection_name collection 
  end

  # group by the groupbycolumn, and sum the sumcolumn, create a result in a collection
  def self.group_by_1key(groupbycolumn, sumcolumn, options = {})
    
    map_function = "function() { emit( {key1: this.#{groupbycolumn}}, 
    {value1: this.#{sumcolumn1}, value2: this.#{sumcolumn2}}); }"
    
    reduce_function = %Q( function(prev, current) { 
      var sum1 = 0; sum2 = 0;

      current.forEach(function(v) {
          sum1 += v['value1'];
          sum2 += v['value2'];
      });

      return {sum1: sum1, sum2: sum2};
    })
    
    Forecast.collection.map_reduce(map_function, reduce_function, options)
  end
        
  # group by the 2 columns
  def self.group_by_2keys(groupbycolumn1, groupbycolumn2, 
    sumcolumn1, sumcolumn2, sumcolumn3, options = {})

    map_function = "function() { 
    emit( {#{groupbycolumn1}: this.#{groupbycolumn1}, #{groupbycolumn2}: this.#{groupbycolumn2}}, 
    {#{sumcolumn1}: this.#{sumcolumn1}, #{sumcolumn2}: this.#{sumcolumn2}, #{sumcolumn3}: this.#{sumcolumn3}}); }"

    reduce_function = %Q( function(prev, current) { 
      var sum1 = 0; sum2 = 0; sum3 = 0;
      
      
      current.forEach(function(v) {
        sum1 += v['#{sumcolumn1}'];
        sum2 += v['#{sumcolumn2}'];
        sum3 += v['#{sumcolumn3}'];        
      });

      return {#{sumcolumn1}: sum1, #{sumcolumn2}: sum2, #{sumcolumn3}: sum3};
    })
        
    Forecast.collection.map_reduce(map_function, reduce_function, options)
  end

  # group by the 3 columns
  def self.group_by_3keys(groupbycolumn1, groupbycolumn2, groupbycolumn3, 
    sumcolumn1, sumcolumn2, sumcolumn3, options = {})

    map_function = "function() { 
    emit( {#{groupbycolumn1}: this.#{groupbycolumn1}, 
      #{groupbycolumn2}: this.#{groupbycolumn2}, 
      #{groupbycolumn3}: this.#{groupbycolumn3}
    }, 
    {#{sumcolumn1}: this.#{sumcolumn1}, #{sumcolumn2}: this.#{sumcolumn2}, #{sumcolumn3}: this.#{sumcolumn3}}); }"

    reduce_function = %Q( function(prev, current) { 
      var sum1 = 0; sum2 = 0; sum3 = 0;
      
      current.forEach(function(v) {
        sum1 += v['#{sumcolumn1}'];
        sum2 += v['#{sumcolumn2}'];
        sum3 += v['#{sumcolumn3}'];        
      });

      return {#{sumcolumn1}: sum1, #{sumcolumn2}: sum2, #{sumcolumn3}: sum3};
    })
        
    Forecast.collection.map_reduce(map_function, reduce_function, options)
  end

end
