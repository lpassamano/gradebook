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
end
