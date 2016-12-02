require_relative 'board'

class Imageboard
  # This is the route for the homepage.
  get '/' do
    locals = {
      title: 'Home :: iikoto',
      type: 'front',
      boards: Board.all
    }

    slim :home, locals: locals
  end
end
