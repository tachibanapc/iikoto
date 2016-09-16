require 'sinatra'
require 'active_record'
require 'yaml'

require_relative 'models/master'

# Read the config file.
begin
  CONFIG = YAML.load_file('config.yml').freeze
rescue Error::ENOENT
  puts "The config file 'config.yml' is missing."
  exit
end

# Establish ActiveRecord's base connection.
ActiveRecord::Base.establish_connection(CONFIG[:connection])

class Imageboard < Sinatra::Base
  # This is the route for the homepage.
  get '/' do
    locals = {
      :boards => Board.all
    }
    
    erb :home, :locals => locals
  end
end
