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
    if params[:role_id] == Role.find_by(name: "Student").id.to_s
      if @user = User.find_by(email: params[:email])
        if @user.authenticate(@user.name)
          @user.password = params[:password]
          session[:user_id] = @user.id
          redirect "/courses"
        end
      elsif User.find_by(email: params[:email])
        #add flash message saying account already created w/ this email
        redirect "/login"
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
    elsif User.find_by(email: params[:email])
        #add flash message saying account already created w/ this email
      redirect "/login"
    else
      create_new_user_or_redirect_signup(params)
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
    def create_new_user_or_redirect_signup(params)
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
end
