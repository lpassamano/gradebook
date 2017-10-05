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
    #simplify this when refactoring -- look at form labels
    course = Course.create(name: params[:course][:name])
    course.users << current_user
    params[:course][:students].each do |student|
      if student[:name] != "" && student[:email] != ""
        s = User.new(name: student[:name], email: student[:email])
        s.password = s.name
        s.save
        s.role = Role.find_or_create_by(name: "Student")
        course.users << s
        course.save
      end
    end
    params[:course][:assessments].each do |assessment|
      #add grade for each student per assessment
      course.assessments << Assessment.create(assessment)
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
    #simplify this when refactoring
    course = Course.find_by_slug(params[:slug])
    course.name = params[:course][:name]
    course.user_ids = params[:course][:user_ids]
    course.users << current_user
    course.assessment_ids = params[:course][:assessment_ids]
    params[:course][:assessments].each do |assessment|
      #need to make sure grades are added for each student for new assessment
      course.assessments << Assessment.create(assessment)
    end
    course.save
    params[:course][:students].each do |student|
      if student[:name] != "" && student[:email] != ""
        #new grades for each course assessment need to be created for each new student
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
end
