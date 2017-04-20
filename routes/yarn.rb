require 'mini_magick'
require 'fileutils'
require 'mimemagic'

class Imageboard
  # Thread view page.
  get '/:board/thread/:number' do
    board = Board.find_by(route: params[:board])
    yarn = Yarn.find_by(number: params[:number])

    if board.nil?
      flash[:error] = "The board you selected doesn't exist!"
      return redirect '/'
    elsif yarn.nil?
      flash[:error] = "The thread you specified doesn't exist!"
      return redirect "/#{board.route}/"
    else
      locals = {
        title: "/#{board.route}/ - #{!yarn.subject.empty? ? yarn.subject.truncate(20) : board.name}",
        type: 'yarn',
        board: board,
        boards: Board.all,
        yarn: yarn,
        replies: yarn.replies
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
      return redirect '/'
    elsif yarn.nil?
      flash[:error] = "The thread you specified doesn't exist!"
      return redirect "/#{board.route}"
    elsif Ban.banned? request.ip
      return redirect '/banned'
    else
      if !params.has_key? "body" and !params.has_key? "file"
        flash[:error] = "You can't make an empty reply!"
        return redirect "/#{board.route}/thread/#{yarn.number}"
      end

      if params.has_key? "body"
        if params[:body].strip.empty?
          flash[:error] = "You cannot make an empty post."
          return redirect "/#{board.route}"
        end

        if params[:body].length > $CONFIG[:character_limit]
          flash[:error] = "Your text post exceeds #{$CONFIG[:character_limit]} characters."
          return redirect "/#{board.route}"
        end
      end

      if params.has_key? "file"
        unless params[:file].is_a? Hash
          flash[:error] = "File parameter must be a file."
          return redirect "/#{board.route}"
        end

        if yarn.image_limit?
          flash[:error] = "The image reply limit has been reached."
          return redirect "/#{board.route}"
        end

        file = params[:file][:tempfile]
        filetype = MimeMagic.by_path(file.path)

        if !filetype.image?
          flash[:error] = "The file you provided is of invalid type."
          return redirect "/#{board.route}"
        end

        if file.size > $CONFIG[:max_filesize]
          flash[:error] = "The file you provided is too large."
          return redirect "/#{board.route}"
        end

        begin
          image = MiniMagick::Image.read(file)
        rescue MiniMagick::Invalid
          flash[:error] = "The image you provided is invalid."
          return redirect "/#{board.route}"
        end

        properties = {}

        if !image.valid?
          flash[:error] = "The image you provided is invalid."
          return redirect "/#{board.route}"
        end

        post = Post.create({
          yarn: yarn.number,
          name: params[:name],
          spoiler: params[:spoiler] == "on",
          time: DateTime.now,
          body: (params[:body].nil?) ? nil : params[:body].strip,
          ip: request.ip
        })

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

        # bump the thread
        unless params.has_key? "sage"
          yarn.updated = DateTime.now
          yarn.save
        end
      else
        if yarn.reply_limit?
          flash[:error] = "The reply limit has been reached."
          return redirect "/#{board.route}"
        end

        Post.create({
          yarn: yarn.number,
          name: params[:name],
          spoiler: params[:spoiler] == "on",
          time: DateTime.now,
          body: (params[:body].nil?) ? nil : params[:body].strip,
          ip: request.ip
        })

        # bump the thread
        unless params.has_key? "sage"
          yarn.updated = DateTime.now
          yarn.save
        end
      end

      return redirect "/#{board.route}/thread/#{yarn.number}"
    end
  end
end
