require 'mini_magick'
require 'fileutils'

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
      uuid: SecureRandom.urlsafe_base64($CONFIG[:url_hash_size])
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
      c.resize "250x250"
    }.format("jpg").write "#{$ROOT}/public/thumbs/#{board.route}/#{filename}"

    image.destroy!

    post = Post.create({
      name: params[:name],
      time: DateTime.now,
      body: params[:body],
      spoiler: params.has_key?(:spoiler)
    })

    yarn = Yarn.create({
      number: post.number,
      board: board.route,
      updated: DateTime.now,
      subject: params[:subject],
      locked: false
    })

    post.yarn = post.number

    imagefile = Image.create({
      post: post.number,
      extension: properties[:type],
      name: filename,
      width: properties[:width],
      height: properties[:height]
    })

    params.to_s
  end
end
