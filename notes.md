To do:

1.6 make more helper methods to make controller actions simpler -- post signup, create/edit course, sort grades by assessment_id

2. add in extra navigation elements (go back and home buttons)
    -error messages

3. format table better in instructor view of course

4. fix tests to all pass


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
