instructor = Role.create(name: "Instructor")
student = Role.create(name: "Student")

chaz = User.create(name: "Chaz", email: "chaz@college.edu", password: "1234")
serge = User.create(name: "Serge", email: "serge@college.edu", password: "1234")
jessie = User.create(name: "Jessie", email: "jessie@college.edu", password: "1234")
instructor.users << [chaz, serge, jessie]

leigh = User.create(name: "Leigh", email: "leigh@college.edu", password: "1234")
gil = User.create(name: "Gil", email: "gil@college.edu", password: "1234")
obi = User.create(name: "Obi", email: "obi@college.edu", password: "1234")
brian = User.create(name: "Brian", email: "brian@college.edu", password: "1234")
ww = User.create(name: "Diana Prince", email: "ww@themyscira.com", password: "Diana Prince")
marty = User.create(name: "Marty McFly", email: "mmcfly@college.edu", password: "Marty McFly")
harry = User.create(name: "Harry Potter", email: "harry@hogwarts.edu", password: "Harry Potter")
ron = User.create(name: "Ron Weasley", email: "ron@hogwarts.edu", password: "Ron Weasley")
hermoine = User.create(name: "Hermoine Granger", email: "hermoine@hogwarts.edu", password: "Hermoine Granger")
student.users << [leigh, gil, obi, brian, ww, marty, harry, ron, hermoine]

physics = Course.create(name: "Physics 101")
food = Course.create(name: "Food Appreciation")
astro = Course.create(name: "Intro to Astronomy")
pl = Course.create(name: "Powerlifting")

physics.users << [chaz, leigh, gil, obi, ww, hermoine]
food.users << [serge, leigh, gil, obi, brian, ron, harry, hermoine]
astro.users << [jessie, obi, gil, ww, marty, hermoine]
pl.users << [jessie, obi, gil, ww, harry, ron]

physics_assessments = [
  "Lab 1",
  "Lab 2",
  "Lab 3",
  "Lab 4",
  "Lab 5",
  "Midterm Exam",
  "Group Project",
  "Final Exam"
]

physics_assessments.each do |assessment|
  a = Assessment.create(name: assessment)
  physics.assessments << a
  physics.save
end

physics_roster = [leigh, gil, obi, ww, hermoine]

physics_roster.each do |student|
  physics.assessments.each do |assessment|
    g = Grade.create
    student.grades << g
    assessment.grades << g
    student.save
    assessment.save
  end
end
