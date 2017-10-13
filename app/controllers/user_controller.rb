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
    if user = User.find_by(email: params[:email])
      if user.student? && user.authenticate(user.name)
        #if password == name that means that the student was created in the create/edit course page and has not created an account yet
        user.password = params[:password]
        session[:user_id] = user.id
        redirect "/courses"
      else
        #add flash message saying account already created w/ this email
        redirect "/login"
      end
    else
      user = User.new(params)
      if user.save && params[:name] != "" && params[:email] != ""
        session[:user_id] = user.id
        redirect "/courses"
      else
          #add flash error message later
        redirect "/signup"
      end
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

  helpers do
    
  end
end
