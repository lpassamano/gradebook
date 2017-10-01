instructor = Instructor.create(name: "Dr. Brown", email: "doc@college.edu", password: "1234")

courses_list = [
  "Physics 201",
  "Advanced Chemistry",
  "Seminar on The Theory of Time Travel"
]

courses_list.each do |course|
  c = Course.create(name: course)
  instructor.courses << c
  instructor.save
end

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

physics = Course.find_by(name: "Physics 201")

physics_assessments.each do |assessment|
  a = Assessment.create(name: assessment)
  physics.assessments << a
  physics.save
end

chemistry_assessments = [
  "Attendence",
  "Class Participation",
  "Lab Participation",
  "Midterm",
  "Final Exam"
]

chemistry = Course.find_by(name: "Advanced Chemistry")

chemistry_assessments.each do |assessment|
  a = Assessment.create(name: assessment)
  chemistry.assessments << a
  chemistry.save
end

seminar_assessments = [
  "Paper Presentation",
  "Research Project",
  "Final Project",
  "Final Project Oral Presentation"
]

seminar = Course.find_by(name: "Seminar on The Theory of Time Travel")

seminar_assessments.each do |assessment|
  a = Assessment.create(name: assessment)
  seminar.assessments << a
  seminar.save
end

marty = Student.create({
  name: "Marty McFly",
  email: "marty@email.com",
  password: "Marty McFly"
})

biff = Student.create({
  name: "Biff",
  email: "bigbiff@email.com",
  password: "Biff"
})

han = Student.create({
  name: "Han Solo",
  email: "han@email.com",
  password: "1234"
})

john_doe = Student.create({
  name: "John Doe",
  email: "john@email.com",
  password: "1234"
})

jane = Student.create({
  name: "Jane Doe",
  email: "jane@email.com",
  password: "1234"
})

john_smith = Student.create({
  name: "John Smith",
  email: "j@college.edu",
  password: "1234"
})

diana = Student.create({
  name: "John Smith",
  email: "j@college.edu",
  password: "1234"
})

hermoine = Student.create({
  name: "Hermoine Granger",
  email: "hermoine@hogwarts.edu",
  password: "1234"
})

ron = Student.create({
  name: "Ron Weasley",
  email: "ron@hogwarts.edu",
  password: "Ron Weasley"
})

harry = Student.create({
  name: "Harry Potter",
  email: "harry@hogwarts.edu",
  password: "Harry Potter"
})

physics_roster = [
  hermoine,
  biff,
  john_smith,
  jane
]

physics_roster.each do |student|
  physics.students << student
  physics.save
  physics.assessments.each do |assessment|
    g = Grade.create
    student.grades << g
    assessment.grades << g
    student.save
    assessment.save
  end
end

chemistry_roster = [
  hermoine,
  harry,
  ron,
  john_doe,
  jane
]

chemistry_roster.each do |student|
  chemistry.students << student
  chemistry.save
  chemistry.assessments.each do |assessment|
    g = Grade.create
    student.grades << g
    assessment.grades << g
    student.save
    assessment.save
  end
end

seminar_roster = [
  hermoine,
  diana,
  han,
  marty,
  john_smith
]

seminar_roster.each do |student|
  seminar.students << student
  seminar.save
  seminar.assessments.each do |assessment|
    g = Grade.create
    student.grades << g
    assessment.grades << g
    student.save
    assessment.save
  end
end
