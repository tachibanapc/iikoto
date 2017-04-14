require_relative 'board'
require_relative 'yarn'

class Imageboard
  # This is the route for the homepage.
  get '/' do
    locals = {
      title: "Home - #{$CONFIG[:site_name]}",
      type: 'front',
      boards: Board.all
    }

    slim :home, locals: locals
  end
end
