To do:

1.6 make more helper methods to make controller actions simpler -- create/edit course, sort grades by assessment_id

2. add in extra navigation elements (go back and home buttons)
    -error messages

3. format table better in instructor view of course

4. fix tests to all pass


sort_assessments_and_grades(course)

@course.assessments.sort_by {|assessment| assessment[:id]}
@course.users.each do |user|
  if user.student?
    user.grades.sort_by {|grade| grade[:assessment_id]}
  end
end
