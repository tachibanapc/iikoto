class Imageboard
  # Board index page.
  get '/:board' do
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

  post '/:board/' do
    board = Board.find_by(route: params[:board])

    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    end

    if !params.has_key? "file"
      flash[:error] = "You can't start a thread with no file!"
      redirect "/#{board.route}"
    end

    filetype = params[:file][:type]

    if !filetype.match(/image\/(jp(e)?g|png|gif)/)
      flash[:error] = "The file you provided is of invalid type."
      redirect "/#{board.route}"
    end

    file = file[:file][:tempfile]

    if file.size > $CONFIG[:max_filesize]
      flash[:error] = "The file you provided is too large."
      redirect "/#{board.route}"
    end

    "u did it fam"
  end
end
