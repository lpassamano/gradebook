class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/courses"
    else
      @roles = Role.all
      erb :"user/signup"
    end
  end

  post '/signup' do
    #binding.pry
    user = User.new(params)
    if user.save && params[:name] != "" && params[:email] != ""
      session[:user_id] = user.id
      redirect "/courses"
    else
      #add flash error message later
      redirect "/signup"
    end
  end

  get '/login' do
    if logged_in?
      redirect "/courses"
    else
      erb :"user/login"
    end
  end

  post '/login' do
    #binding.pry
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/courses"
    else
      #add flash error message later
      redirect "/login"
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect "/"
  end
end
