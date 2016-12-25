require 'mini_magick'
require 'fileutils'

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
        title: "/#{board.route}/ :: #{!yarn.subject.empty? ? yarn.subject.truncate(20) : board.name}",
        type: 'yarn',
        board: board,
        boards: Board.all,
        yarn: yarn,
        replies: Post.where(yarn: yarn.number)
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
      if (!params.has_key? "body" or params[:body].empty?) and !params.has_key? "file"
        flash[:error] = "You can't make an empty reply!"
        redirect "/#{board.route}/thread/#{yarn.number}"
      end

      post = Post.create({
        yarn: yarn.number,
        name: params[:name],
        spoiler: params[:spoiler],
        time: DateTime.now,
        body: params[:body]
      })

      if params.has_key? "file"
        filetype = params[:file][:type]
        if !filetype.match(/image\/jp(e)?g|png|gif/)
          flash[:error] = "The file you provided is of invalid type."
          redirect "/#{board.route}"
        end

        file = params[:file][:tempfile]

        if file.size > $CONFIG[:max_filesize]
          flash[:error] = "The file you provided is too large."
          redirect "/#{board.route}"
        end

        image = MiniMagick::Image.read(file)
        properties = {}

        if !image.valid?
          flash[:error] = "The image you provided is invalid."
          redirect "/#{board.route}"
        end

        # Generate a UUID
        properties.merge!({
            uuid: Image.uuid
        })

        # Establish the image's common properties.
        properties.merge!({
          width: image.width,
          height: image.height,
          type: image.type.downcase
        })

        # Save the original.
        if !Dir.exist? "#{$ROOT}/public/images/#{board.route}"
          FileUtils.mkpath "#{$ROOT}/public/images/#{board.route}"
        end

        filename = "#{properties[:uuid]}.#{properties[:type]}"
        image.write "#{$ROOT}/public/images/#{board.route}/#{filename}"

        # Save the thumbnail.
        if !Dir.exist? "#{$ROOT}/public/thumbs/#{board.route}"
          FileUtils.mkpath "#{$ROOT}/public/thumbs/#{board.route}"
        end

        image.combine_options { |c|
          c.resize "125x125"
        }.format("jpg").write "#{$ROOT}/public/thumbs/#{board.route}/#{filename}"

        image.destroy!

        Image.create({
          post: post.number,
          extension: properties[:type],
          name: filename,
          width: properties[:width],
          height: properties[:height]
        })
      end

      redirect "/#{board.route}/thread/#{yarn.number}"
    end
  end
end
