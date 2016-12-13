require 'sinatra'
require 'sinatra/flash'
require 'active_record'
require 'yaml'
require 'sass/plugin/rack'

require_relative 'models/master'
require_relative 'core_ext'

# Read the config file.
begin
  $CONFIG = YAML.load_file('config.yml').freeze

  # An assertion function for fields in the config.
  def assert_config(field)
    if !$CONFIG.has_key?(field)
      raise "The config file is missing #{field}" unless $CONFIG.has_key?(field)
    end
  end

  assert_config(:connection)
  assert_config(:max_filesize)
  assert_config(:reply_limit)
  assert_config(:image_limit)
  assert_config(:default_name)
rescue Exception => e
  puts e
  puts "The config file 'config.yml' is missing."
  exit 1
end

# Establish ActiveRecord's base connection.
ActiveRecord::Base.establish_connection($CONFIG[:connection])

class Imageboard < Sinatra::Base
  # Enable Rack CSRF protection and flashes.
  enable :sessions
  register Sinatra::Flash
  set :public_folder, File.dirname(__FILE__) + "/public"

  Sass::Plugin.options[:style] = :compressed
  use Sass::Plugin::Rack

  require_relative 'routes/main'
end
