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
    course.update(params[:course])

      #when assessments are removed their grades need to also be removed
    #params[:course][:assessments].each do |assessment|
      #need to make sure grades are added for each student for new assessment
      #course.assessments << Assessment.create(assessment) if assessment[:name] != ""
    #end
    #course.save
    #params[:course][:students].each do |student|
      #if student[:name] != "" && student[:email] != ""
        #new grades for each course assessment need to be created for each new student
        #s = User.new(name: student[:name], email: student[:email])
        #s.password = s.name
        #s.save
        #s.role = Role.find_or_create_by(name: "Student")
        #course.users << s
        #course.save
      #end
    #end
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
    #params returns hash:
    #  {grade_ids: {
    #      1: {
    #        score: xx, comment: xx
    #      },
    #      2: {
    #        score: xx, comment: xx
    #      }
    #    }
    #  }
    params[:grade_ids].each do |key, value| #key is grade.id value is hash with grade.score and grade.comment
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
