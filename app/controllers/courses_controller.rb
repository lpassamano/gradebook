class CoursesController < ApplicationController

  get '/courses' do
    redirect '/' if !logged_in?
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    redirect '/' if !logged_in?
    erb :"courses/new"
  end

  post '/courses' do
    course = Course.create(name: params[:course][:name])
    students = params[:course][:students].each do |student|
      if student[:name] != "" && student[:email] != ""
        s = Student.new(name: student[:name], email: student[:email])
        s.password = s.name
        s.save
        course.students << s
        course.save
      end
    end
    redirect "/courses/#{course.slug}"
  end

  get '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    erb :"courses/show"
  end
end
