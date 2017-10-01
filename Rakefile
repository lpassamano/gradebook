require_relative './config/environment'

require 'sinatra/activerecord/rake'
require 'database_cleaner'

task :console do
  Pry.start
end

DatabaseCleaner.strategy = :truncation
task :clear_db do
  DatabaseCleaner.clean
end
