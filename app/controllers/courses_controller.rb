class CoursesController < ApplicationController

  get '/courses' do
    redirect '/' if !logged_in?
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    if !logged_in?
      redirect '/'
    elsif current_user.instructor?
      erb :"courses/new"
    else
      redirect '/courses'
    end
  end

  post '/courses' do
    course = Course.create(name: params[:course][:name])
    course.users << current_user
    params[:course][:students].each do |student|
      #binding.pry
      if student[:name] != "" && student[:email] != ""
        s = User.new(name: student[:name], email: student[:email])
        s.password = s.name
        s.save
        s.role = Role.find_or_create_by(name: "Student")
        course.users << s
        course.save
      end
    end
    redirect "/courses/#{course.slug}"
  end

  get '/courses/:slug' do
    #binding.pry
    redirect '/' if !logged_in?
    @course = Course.find_by_slug(params[:slug])
    #binding.pry
    if current_user.instructor? && current_user.courses.include?(@course)
      @course.assessments.sort_by {|assessment| assessment[:id]}
      @course.users.each do |user|
        if user.student?
          user.grades.sort_by {|grade| grade[:assessment_id]}
        end
      end
      erb :"courses/show"
    elsif current_user.student?
      erb :"courses/show_student_user"
    else
      redirect "/courses"
    end
  end

  get '/courses/:slug/edit' do
    if !logged_in?
      redirect '/'
    elsif current_user.instructor?
      @course = Course.find_by_slug(params[:slug])
      erb :"courses/edit"
    else
      redirect '/courses'
    end
  end

  post '/courses/:slug' do
    course = Course.find_by_slug(params[:slug])
    course.name = params[:course][:name]
    course.user_ids = params[:course][:user_ids]
    course.users << current_user
    course.save
    params[:course][:students].each do |student|
      #binding.pry
      if student[:name] != "" && student[:email] != ""
        #binding.pry
        s = User.new(name: student[:name], email: student[:email])
        s.password = s.name
        s.save
        s.role = Role.find_or_create_by(name: "Student")
        course.users << s
        course.save
        #binding.pry
      end
    end
    redirect "/courses/#{course.slug}"
  end
end
