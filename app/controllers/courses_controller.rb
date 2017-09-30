class CoursesController < ApplicationController

  get '/courses' do
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    erb :"courses/new"
  end

  post '/courses' do
    course = Course.create(name: params[:course][:name])
    students = params[:course][:students].collect do |student|
      if student[:name] != "" && student[:email] != ""
        s = Student.new(name: student[:name], email: student[:email])
        s.password = s.name
        s.save
      end
    end
    course.students << students
    course.save 
    redirect "/courses/#{course.slug}"
  end
end
