class Imageboard
  get '/admin' do
    locals = {
      title: "Admin Login - #{$CONFIG[:site_name]}",
      type: 'admin',
      boards: Board.all
    }

    slim :admin, locals: locals
  end

  get '/logout' do
    if !session[:user].nil?
      session[:user] = nil
      flash[:error] = "You are now logged out."
    end

    return redirect '/'
  end

  post '/admin' do
    if !params.has_key?("username") or !params.has_key?("password")
      flash[:error] = "Username or password missing."
      return redirect "/admin"
    end

    if !User.exists?(params[:username])
      flash[:error] = "Username or password invalid!"
      return redirect "/admin"
    end

    if !User.authorized?(params[:username], params[:password])
      flash[:error] = "Username or password invalid!"
      return redirect "/admin"
    end

    session[:user] = params[:username]
    flash[:error] = "You are now logged in."
    return redirect "/"
  end
end
