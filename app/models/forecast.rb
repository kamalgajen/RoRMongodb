class Forecast
  include MongoMapper::Document

  key :productid, Integer
  key :locationid, Integer
  key :divisionid, Integer
  key :calendarid, Integer
  key :productcategoryid, Integer
  key :startdate, Date
  key :enddate, Date
  key :optunitvol, Integer
  key :optrev, Float
  key :optgrossmargin, Float

end
