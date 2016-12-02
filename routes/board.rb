class Imageboard
  # Board index page.
  get('/:board') do
    redirect "/#{params[:board]}/"
  end

  get '/:board/' do
    board = Board.find_by(route: params[:board])
    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    else
      locals = {
        title: "/#{board.route}/ :: #{board.name}",
        type: 'catalog',
        board: board,
        boards: Board.all,
        yarns: board.yarns.reverse
      }

      slim :board, locals: locals
    end
  end
end
