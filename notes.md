To do:

1.6 make more helper methods to make controller actions simpler -- post signup, create/edit course, sort grades by assessment_id

2. add in extra navigation elements (go back and home buttons)
    -error messages

3. format table better in instructor view of course

4. fix tests to all pass


params[:users].collect do |user|
  if user[:name] != "" && user[:email] != ""
    if u = User.find_by(email: user[:email])
      course.users << u if u.student?
    else u = User.new(user)
      u.password = u.name
      u.save
      course.users << u
    end
  end
end
