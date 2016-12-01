class Imageboard
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
      redirect "/#{board.route}/"
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
