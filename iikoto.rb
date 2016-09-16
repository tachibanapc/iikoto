require 'sinatra'
require 'sinatra/flash'
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
  # Enable Rack CSRF protection and flashes.
  enable :sessions
  register Sinatra::Flash
  
  # This is the route for the homepage.
  get '/' do
    locals = {
      :boards => Board.all
    }
    
    erb :home, :locals => locals
  end

  # Board index page.
  get '/:board' do
    board = Board.find_by(route: params[:board])
    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    else
      locals = {
        board: board,
        boards: Board.all,
        yarns: board.yarns.reverse
      }
      
      erb :board, :locals => locals
    end
  end

  # Thread view page.
  # get '/:board/thread/:number' do
  # end
end
