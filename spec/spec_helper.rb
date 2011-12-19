require 'active_record'
require 'factory_girl_rails'
require 'typed_serialize'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false
load "schema.rb"
