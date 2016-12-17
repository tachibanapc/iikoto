class Imageboard
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

  # when u post 👌
  post '/:board/thread/:number' do
    board = Board.find_by(route: params[:board])
    yarn = Yarn.find_by(number: params[:number])

    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      redirect '/'
    elsif yarn.nil?
      flash[:error] = "The thread you specified doesn't exist!"
      redirect "/#{board.route}"
    else
      if body.empty?
        flash[:error] = "You can't make an empty reply!"
        redirect "/#{board.route}/thread/#{yarn.number}"
      end

      Post.create({
        yarn: yarn.number,
        name: params[:name],
        spoiler: params[:spoiler],
        time: DateTime.now,
        body: params[:body]
      })

      redirect "/#{board.route}/thread/#{yarn.number}"
    end
  end
end
