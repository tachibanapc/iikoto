require 'sinatra'
require 'sinatra/flash'
require 'active_record'
require 'yaml'

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

  # CSS route
  get '*.css' do
    # ???
  end

  # This is the route for the homepage.
  get '/' do
    locals = {
      title: 'Home :: iikoto',
      type: 'home',
      boards: Board.all
    }
    
    slim :home, locals: locals
  end

  # Board index page.
  get('/:board') { redirect "/#{params[:board]}/" }

  get '/:board/' do
    board = Board.find_by(route: params[:board])
    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    else
      locals = {
        title: "/#{board.route}/ :: #{board.name}",
        type: 'board',
        board: board,
        boards: Board.all,
        yarns: board.yarns.reverse
      }
      
      slim :board, locals: locals
    end
  end

  # Thread view page.
  get '/:board/thread/:number' do
    board = Board.find_by(route: params[:board])
    yarn = Yarn.find_by(number: params[:number])
    
    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    elsif yarn.nil?
      flash[:error] = "The thread you specified doesn't exist!"
      redirect "/#{board.route}"
    else
      locals = {
        title: "/#{board.route}/ :: #{yarn.subject.truncate(20) || board.name}",
        type: 'yarn',
        board: board,
        boards: Board.all,
        yarn: yarn,
        replies: Post.where(yarn: yarn.number)[1..-1]
      }
      
      slim :yarn, locals: locals
    end
  end
end
