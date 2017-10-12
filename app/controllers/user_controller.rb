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
    if params[:role_id] == Role.find_by(name: "Student").id
      #then check to see if there is already a student with that email enrolled in any classes
      if @user = User.find_by(email: params[:email]) && @user.name == @user.password
        @user.password = params[:password]
        erb :"user/new_student"
        #to page showing courses they are enrolled in, form w/ checks so they can choose to drop classes
      end
    else
      user = User.new(params)
    end
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
