class CoursesController < ApplicationController

  get '/courses' do
    redirect '/' if !logged_in?
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    redirect '/' if !logged_in?
    redirect '/courses' if current_user_student?
    erb :"courses/new"
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
    redirect '/' if !logged_in?
    @course = Course.find_by_slug(params[:slug])
    @course.assessments.sort_by {|assessment| assessment[:id]}
    @course.students.each do |student|
      student.grades.sort_by {|grade| grade[:assessment_id]}
    end
    erb :"courses/show"
  end
end
