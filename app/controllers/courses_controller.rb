class CoursesController < ApplicationController

  get '/courses' do
    redirect '/' if !logged_in?
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    #binding.pry
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
    students = params[:course][:students].each do |student|
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
          user.grades.sort_by {|grade|     grade[:assessment_id]}
        end
      end
      erb :"courses/show"
    elsif current_user.student?
      erb :"courses/show_student_user"
    else
      redirect "/courses"
    end
  end
end
