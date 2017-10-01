class InstructorController < ApplicationController
  #change name to UserController

  get '/instructor/signup' do
    if logged_in?
      redirect "/courses"
    else
      erb :"instructor/signup"
    end
  end

  post '/instructor/signup' do
    instructor = Instructor.new(params)
    if instructor.save && params[:name] != "" && params[:email] != ""
      session[:user_id] = instructor.id
      redirect "/courses"
    else
      #add flash error message later
      redirect "/instructor/signup"
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
