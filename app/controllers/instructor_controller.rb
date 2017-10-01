class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/courses"
    else
      erb :"user/signup"
    end
  end

  post '/signup' do
    user = User.new(params)
    if user.save && params[:name] != "" && params[:email] != ""
      session[:user_id] = user.id
      redirect "/courses"
    else
      #add flash error message later
      redirect "/signup"
    end
  end

  get '/instructor/login' do
    if logged_in?
      redirect "/instructor/courses"
    else
      erb :"instructor/login"
    end
  end

  post '/instructor/login' do
    instructor = Instructor.find_by(email: params[:email])
    if instructor && instructor.authenticate(params[:password])
      session[:user_id] = instructor.id
      redirect "/courses"
    else
      #add flash error message later
      redirect "/instructor/login"
    end
  end
end
