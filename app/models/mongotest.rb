class Mongotest
  include MongoMapper::Document

  key :key, String
  key :value, Integer

end
