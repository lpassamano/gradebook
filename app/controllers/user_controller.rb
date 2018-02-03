require 'rack-flash'

class UserController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      redirect "/courses"
    else
      @roles = Role.all
      erb :"user/signup"
    end
  end

  post '/signup' do
    ##
    if user = User.find_by(email: params[:email])
      if user.student? && user.authenticate(user.name)
        #if password == name then student was created in the new/edit course form and does not have an account
        user.password = params[:password]
        session[:user_id] = user.id
        # let them know they already have an acccount and have them set new password
        redirect "/courses"
      else
        flash[:message] = "Account already created with this email. Please login to access Gradebook."
        # don't redirect to login
        redirect "/login"
      end
    else
      user = User.new(params)
      if !!params[:role_id] && params[:name] != "" && params[:email] != "" && user.save
        session[:user_id] = user.id
        redirect "/courses"
      else
        flash[:message] = "Please enter name, email, password, and account type to signup for Gradebook."
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
      flash[:message] = "Incorrect email and/or password. Please try to login again or signup for a new account."
      redirect "/"
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect "/"
  end
end
