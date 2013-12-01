RoR + mongodb application

The application allows for querying a large dataset via some of the keys (with and without index) and allows aggregation (using map-reduce within Mongo).


###########################################################################
# setup
###########################################################################
Install ruby (if not available already)

# install libraries
gem install mongo
gem install bson_ext
gem install bundler
gem install rails

Add the following to your Gemfile - 
  require 'mongo'
  gem 'mongo_mapper'
  gem 'bson_ext'

Install mongodb
Set the mongodb bin location to your environment PATH variable
Create a database 'perf'
Create a collection 'forecasts'
Load using command below - 
  ./mongoimport -d perf -c forecasts -type csv --headerline "data/sample_data.csv"
Sample dataset included in data/sample_data.csv

# start server 
rails s -p 10000

# Access
http://localhost:10000/forecasts/summary
