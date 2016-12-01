require 'sinatra'
require 'sinatra/flash'
require 'active_record'
require 'yaml'
require 'sass/plugin/rack'

require_relative 'models/master'
require_relative 'core_ext'

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
  # Enable Rack CSRF protection and flashes.
  enable :sessions
  register Sinatra::Flash
  set :public_folder, File.dirname(__FILE__) + "/public"

  Sass::Plugin.options[:style] = :compressed
  use Sass::Plugin::Rack

  require_relative 'routes/main'
end
