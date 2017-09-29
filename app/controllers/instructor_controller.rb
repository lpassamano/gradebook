class InstructorController < ApplicationController

  get '/instructor/signup' do
    erb :"instructor/signup"
  end

  post '/instructor/signup' do
    instructor = Instructor.new(params)
    if instructor.save && params[:name] != "" && params[:email] != ""
      session[:user_id] = instructor.id
      redirect "/instructor/courses"
    else
      #add flash error message later
      redirect "/instructor/signup"
    end
  end

  get '/instructor/login' do
    erb :"instructor/login"
  end

  post '/instructor/login' do
    instructor = Instructor.find_by(email: params[:email])
    if instructor && instructor.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/instructor/courses"
    else
      #add flash error message later
      redirect "/instructor/login"
    end
  end
end
