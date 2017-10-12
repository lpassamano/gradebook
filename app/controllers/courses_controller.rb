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
    course = Course.create(params[:course])
    params[:users].collect do |user|
      if user[:name] != "" && user[:email] != ""
        if u = User.find_by(email: user[:email])
          u.courses << course unless u.instructor?
        else u = User.new(user)
          u.password = u.name
          u.save
          u.courses << course
        end
      end
    end
    params[:assessments].each do |assessment|
      if assessment[:name] != ""
        a = Assessment.create(assessment)
        course.assessments << a
        course.users.each do |user|
          if user.student?
            grade = Grade.create
            user.grades << grade
            a.grades << grade
          end
        end
      end
    end
    redirect "/courses/#{course.slug}"
  end

  get '/courses/:slug' do
    redirect '/' if !logged_in?
    @course = Course.find_by_slug(params[:slug])
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
    @course = Course.find_by_slug(params[:slug])
    if !logged_in?
      redirect '/'
    elsif current_user.instructor? && current_user.courses.include?(@course)
      erb :"courses/edit"
    else
      redirect '/courses'
    end
  end

  post '/courses/:slug' do
    #simplify this when refactoring
    course = Course.find_by_slug(params[:slug])
    if params[:course][:assessment_ids] == nil
      removed_assmnts = course.assessment_ids
    else
      removed_assmnts = course.assessment_ids.find_all do |id|
        !params[:course][:assessment_ids].include?(id.to_s)
      end
    end
    course.update(params[:course])
    params[:users].collect do |user|
      if user[:name] != "" && user[:email] != ""
        if u = User.find_by(email: user[:email]) && u.student?
          u.courses << course
          course.assessments.each do |assessment|
            grade = Grade.create
            u.grades << grade
            assessment.grades << grade
          end
        else u = User.new(user)
          u.password = u.name
          u.save
          u.courses << course
          course.assessments.each do |assessment|
            grade = Grade.create
            u.grades << grade
            assessment.grades << grade
          end
        end
      end
    end
    params[:assessments].each do |assessment|
      if assessment[:name] != ""
        a = Assessment.create(assessment)
        course.assessments << a
        course.users.each do |user|
          if user.student?
            grade = Grade.create
            user.grades << grade
            a.grades << grade
          end
        end
      end
    end
    course.users.each do |user|
      if user.student?
        user.grades.each do |grade|
          grade.delete if removed_assmnts.include?(grade.assessment_id)
        end
      end
    end
    binding.pry
    redirect "/courses/#{course.slug}"
  end

  get '/courses/:slug/grades' do
    @course = Course.find_by_slug(params[:slug])
    if !logged_in?
      redirect "/"
    elsif current_user.instructor? && current_user.courses.include?(@course)
      @course.assessments.sort_by {|assessment| assessment[:id]}
      @course.users.each do |user|
        if user.student?
          user.grades.sort_by {|grade| grade[:assessment_id]}
        end
      end
      erb :"courses/grades"
    else
      redirect "/courses"
    end
  end

  post '/courses/:slug/grades' do
    course = Course.find_by_slug(params[:slug])
    params[:grade_ids].each do |key, value|
      grade = Grade.find(key.to_i)
      grade.update(value)
    end
    redirect "/courses/#{course.slug}"
  end

  delete '/courses/:slug/delete' do
    @course = Course.find_by_slug(params[:slug])
    if !logged_in?
      redirect "/"
    elsif current_user.instructor? && current_user.courses.include?(@course)
      @course.delete
      erb :"courses/delete"
    else
      redirect "/courses"
    end
  end
end
