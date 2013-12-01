class ForecastsController < ApplicationController

  # GET /forecasts
  # GET /forecasts.json
  def index
  @forecasts = Forecast.where(:productid => 1).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forecasts }
    end
  end
    
  # GET /forecasts/summary
  def summary
    @totalcount = Forecast.count
    @productcount = Forecast.sort(:productid.desc).first.productid
    #@divisioncount = MongoMapper.database.collection("forecasts").distinct("divisionid").count
    @divisioncount = Forecast.sort(:divisionid.desc).first.divisionid
    @calendarcount = Forecast.sort(:calendarid.desc).first.calendarid
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /forecasts/search
  # GET /forecasts/search.json
  def search
    
    @querystring = ""
    if params[:productid] && params[:productid] != ""
      @productid = params[:productid].to_i
      @querystring += ":productid => " + @productid.to_s
    end
    
    if params[:locationid] && params[:locationid] != ""
      @locationid = params[:locationid].to_i
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":locationid => " + @locationid.to_s
    end
    
    if params[:divisionid] && params[:divisionid] != ""
      @divisionid = params[:divisionid].to_i
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":divisionid => " + @divisionid.to_s
    end
    
    if params[:calendarid] && params[:calendarid] != ""
      @calendarid = params[:calendarid].to_i
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":calendarid => " + @calendarid.to_s
    end
    
    if params[:beginstartdate] && params[:beginstartdate] != ""
      @beginstartdate = params[:beginstartdate]
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":startdate.gt => \"" + @beginstartdate.to_s + "\""
    end
    if params[:endstartdate] && params[:endstartdate] != ""
      @endstartdate = params[:endstartdate]
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":startdate.lt => \"" + @endstartdate.to_s + "\""
    end
    
    if params[:beginenddate] && params[:beginenddate] != ""
      @beginenddate = params[:beginenddate]
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":enddate.gt => \"" + @beginenddate.to_s + "\""
    end
    if params[:endenddate] && params[:endenddate] != ""
      @endenddate = params[:endenddate]
      if @querystring != ""
        @querystring += ", "
      end
      @querystring += ":enddate.lt => \"" + @endenddate.to_s + "\""
    end
    
    if @productid || @locationid || @divisionid || @calendarid || @beginstartdate || @endstartdate || 
      @beginenddate || @endenddate
      @forecasts = eval ("Forecast.where(" + @querystring + ").limit(1000)")

      respond_to do |format|
        format.html # search.html.erb
        format.json { render json: @forecasts }
      end
    else
      @forecasts = ()
    end
    
  end
  
  # GET /forecasts/aggregate
  # GET /forecasts/aggregate.json
  def aggregate

    # intitialize aggregation types and releted reporting paramters
    @aggtype = ""
    if params[:aggtype] && params[:aggtype] == "pdwtodw"
      @aggtype = params[:aggtype]
      @headers = ["Division Id", "Calendar Id", "Volume", "Revenue", "Margin"]
    elsif params[:aggtype] && params[:aggtype] == "pdwtopd"
      @aggtype = params[:aggtype]
      @headers = ["ProductId", "DivisionId", "Volume", "Revenue", "Margin"]
    end
    
    # deal with aggregation request
    # based on the type, a aggregation collection is created - this will be used for future searches
    # NOTE: actual aggregations are kicked off by map-reduce here
    if params[:requesttype] && params[:requesttype] == "aggregation"

      if @aggtype == "pdwtodw"
        
        Aggregate.group_by_2keys(:divisionid, :calendarid,
          :optunitvol, :optrev, :optgrossmargin, 
          :out => @aggtype)

      elsif @aggtype == "pdwtopd"

        Aggregate.group_by_2keys(:productid, :divisionid, 
          :optunitvol, :optrev, :optgrossmargin, 
          :out => @aggtype)

      end
    
    
    # deal with search requests
    # based on the query filters, and aggregation to use, provide the result set
    elsif params[:requesttype] && params[:requesttype] == "search"
      @querystring = ""

      if params[:productid] && params[:productid] != ""
        @productid = params[:productid].to_i
        @querystring += "\"_id.productid\" => " + @productid.to_s
      end

      if params[:locationid] && params[:locationid] != ""
        @locationid = params[:locationid].to_i
        if @querystring != ""
          @querystring += ", "
        end
        @querystring += "\"_id.locationid\" => " + @locationid.to_s
      end

      if params[:divisionid] && params[:divisionid] != ""
        @divisionid = params[:divisionid].to_i
        if @querystring != ""
          @querystring += ", "
        end
        @querystring += "\"_id.divisionid\" => " + @divisionid.to_s
      end

      if params[:calendarid] && params[:calendarid] != ""
        @calendarid = params[:calendarid].to_i
        if @querystring != ""
          @querystring += ", "
        end
        @querystring += "\"_id.calendarid\" => " + @calendarid.to_s
      end

      #@aggtype = "plwtopdw"
      #@headers = ["Product Id", "Division Id", "Calendar Id", "Opt Revenue", "Opt Unit Volume", "Total Cost"]
      #@agg = eval ("MongoMapper.database.collection(\"" + @aggtype + "\").find(\"_id.productid\" => 1, \"_id.divisionid\" => 1)")
      @agg = eval ("MongoMapper.database.collection(\"" + @aggtype + "\").find(" + @querystring + ").limit(1000)")

      respond_to do |format|
        format.html # agregate.html.erb
        format.json { render json: @agg }
      end

    end

  end

  # GET /forecasts/1
  # GET /forecasts/1.json
  def show
    @forecast = Forecast.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forecast }
    end
  end

  # GET /forecasts/new
  # GET /forecasts/new.json
  def new
    @forecast = Forecast.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forecast }
    end
  end

  # GET /forecasts/1/edit
  def edit
    @forecast = Forecast.find(params[:id])
  end

  # POST /forecasts
  # POST /forecasts.json
  def create
    @forecast = Forecast.new(params[:forecast])

    respond_to do |format|
      if @forecast.save
        format.html { redirect_to @forecast, notice: 'Forecast was successfully created.' }
        format.json { render json: @forecast, status: :created, location: @forecast }
      else
        format.html { render action: "new" }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forecasts/1
  # PUT /forecasts/1.json
  def update
    @forecast = Forecast.find(params[:id])

    respond_to do |format|
      if @forecast.update_attributes(params[:forecast])
        format.html { redirect_to @forecast, notice: 'Forecast was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecasts/1
  # DELETE /forecasts/1.json
  def destroy
    @forecast = Forecast.find(params[:id])
    @forecast.destroy

    respond_to do |format|
      format.html { redirect_to forecasts_url }
      format.json { head :no_content }
    end
  end
end
