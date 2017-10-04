require 'spec_helper'

describe "Course Features" do
  describe "Courses Index" do
    before do
      @student = Role.create(name: "Student")
      @instructor = Role.create(name: "Instructor")
      @user = User.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      @user.role = @instructor
      course1 = Course.create(name: "Physics 115")
      course2 = Course.create(name: "Art History 101")
      @user.courses. << [course1, course2]
      @user.save
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/login', params
    end

    it 'shows all courses associated with the current user' do
      get '/courses'
      expect(last_response.body).to include("Physics 115")
      expect(last_response.body).to include("Art History 101")
    end

    it "has a link to each course's show page" do
      get '/courses'
      expect(last_response.body).to include("<a href=\"/courses")
    end

    it 'has a link to add a new course if the user is an instructor' do
      get '/courses'
      expect(last_response.body).to include("<a href=\"/courses/new\"")
    end

    it 'does not have a link to add a new course if the user is a student ' do
      get '/logout'
      student = User.new(name: "Leigh", email: "test@leigh.com", password: "1234")
      student.role = Role.find_or_create_by(name: "Student")
      student.save
      params = {email: "test@leigh.com", password: "1234"}
      post '/login', params
      get '/courses'
      expect(last_response.body).not_to include("Add New Course")
    end

    it 'can only be viewed if logged in' do
      get '/logout'
      get '/courses/new'
      expect(last_response.location).to include("/")
    end
  end

  describe "New Course Form" do
    before do
      Role.find_or_create_by(name: "Student")
      Role.find_or_create_by(name: "Instructor")

      user = User.create(name: "Leigh", email: "leigh@university.edu", password: "1234")
      user.role = Role.find_by(name: "Instructor")
      user.save
      params = {email: "leigh@university.edu", password: "1234"}
      post '/login', params
    end

    it 'has a form to add a new course' do
      Role.find_or_create_by(name: "Instructor")
      user = User.create(name: "Leigh", email: "leigh@university.edu", password: "1234")
      user.role = Role.find_by(name: "Instructor")
      user.save
      params = {email: "leigh@university.edu", password: "1234"}
      post '/login', params
      get '/courses/new'
      expect(last_response.body).to include("<form")
    end

    it 'has fields for entering course name and up to 15 students' do
      get '/courses/new'
      expect(last_response.body).to include("course[name]")
      expect(last_response.body).to include("15")
    end

    it 'redirects to the show page for the new course after the form is submitted' do
      course = Course.create(name: "Philosophy 101")
      params = {name: "Philosophy 101"}
      post '/courses', params
      expect(last_response.body).to include("Philosophy 101")
    end

    it 'creates a new instance of user with a role of student for each student entered into the roster' do
      params = {
        :course => {
          :name => "Beginner Painting",
          :students => [
            {
              :name => "Juila",
              :email => "julia@email.com"
            },
            {
              :name => "Gil",
              :email => "gil@email.com"
            },
            {
              :name => "Serge",
              :email => "serge@email.com"
            }
          ]
        }
      }
      post '/courses', params
      course = Course.find_by(name: "Beginner Painting")
      #binding.pry
      roles = course.users.collect { |user| user.role.name }
      expect(roles.count("Student")).to eq(3)
    end

    it 'can only be viewed if logged in' do
      get '/logout'
      get '/courses/new'
      expect(last_response.location).to include("/")
    end

    it 'does not allow student users to view the form' do
      get '/logout'
      student = User.create(email: "test@test.com", password: "1234")
      student.role = Role.find_or_create_by(name: "Student")
      student.save
      params = {email: "test@test.com", password: "1234"}
      post '/login', params
      get '/courses/new'
      expect(last_response.location).to include("/courses")
    end
  end

  describe "Course Show Page" do
    before do
      instructor = Role.find_or_create_by(name: "Instructor")
      student = Role.find_or_create_by(name: "Student")
      user = User.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      user.role = instructor
      user.save
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/login', params

      @course = Course.create(name: "Photography")
      becky = User.create(name: "Becky", email: "becky@test.edu", password: "Becky")
      becky.role = student
      becky.save
      chaz = User.create(name: "Chaz", email: "chaz@test.edu", password: "Chaz")
      chaz.role = student
      chaz.save
      report = Assessment.create(name: "Report")
      essay = Assessment.create(name: "Essay")
      exam = Assessment.create(name: "Final Exam")
      @course.users << [becky, chaz]
      @course.assessments << [report, essay, exam]
      @course.save
      becky_report = Grade.create(score: "75")
      becky_essay = Grade.create(score: "80")
      becky_exam = Grade.create(score: "50")
      chaz_report = Grade.create(score: "79")
      chaz_essay = Grade.create(score: "55")
      chaz_exam = Grade.create(score: "105")
      report.grades << [becky_report, chaz_report]
      report.save
      essay.grades << [becky_essay, chaz_essay]
      essay.save
      exam.grades << [becky_exam, chaz_exam]
      exam.save
      becky.grades << [becky_exam, becky_report, becky_essay]
      becky.save
      chaz.grades << [chaz_exam, chaz_report, chaz_essay]
      chaz.save
    end

    it 'displays the course name, student roster, assigments, and student grades' do
      get "/courses/#{@course.slug}"
      expect(last_response.body).to include("Photography")
      expect(last_response.body).to include("Becky")
      expect(last_response.body).to include("Essay")
      expect(last_response.body).to include("80")
    end

    it 'can only be viewed when logged in' do
      get '/logout'
      get "/courses/#{@course.slug}"
      expect(last_response.location).to include("/")
    end

    it 'has a link to edit the course information' do
      get "/courses/#{@course.slug}"
      expect(last_response.body).to include("<a href=\"/courses/#{@course.slug}/edit\"")
    end

    it 'has a link to add assessment form' do
      get "/courses/#{@course.slug}"
      expect(last_response.body).to include("<a href=\"/courses/#{@course.slug}/new\"")
    end

    it 'has a link for each existing assessment to individual assessment show page' do
      get "/courses/#{@course.slug}"
      expect(last_response.body).to include("<a href=\"/courses/#{@course.slug}/#{@course.assessments.first.slug}\"")
    end

    it 'course show page for student users only displays their grades' do
      student = User.create(name: "Rich", email: "rich@email.com", password: "1234")
      student.role = Role.find_or_create_by(name: "Student")
      student.save
      params = {email: "rich@email.com", password: "1234"}
      get '/logout'
      post '/login', params
      get "/courses/#{@course.slug}"

      expect(last_response.body).not_to include("Becky")
      expect(last_response.body).not_to include("Essay")
      expect(last_response.body).not_to include("80")
    end

    it 'course show page for student does not have links to edit course or add new assessments' do

    end
  end

  describe "Edit Course Form" do
    before do
      instructor = Role.find_or_create_by(name: "Instructor")
      student = Role.find_or_create_by(name: "Student")
      user = User.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      user.role = instructor
      user.save
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/login', params

      @course = Course.create(name: "Photography")
      becky = User.create(name: "Becky", email: "becky@test.edu", password: "Becky")
      becky.role = student
      becky.save
      chaz = User.create(name: "Chaz", email: "chaz@test.edu", password: "Chaz")
      chaz.role = student
      chaz.save
      report = Assessment.create(name: "Report")
      essay = Assessment.create(name: "Essay")
      exam = Assessment.create(name: "Final Exam")
      @course.users << [becky, chaz]
      @course.assessments << [report, essay, exam]
      @course.save
      becky_report = Grade.create(score: "75")
      becky_essay = Grade.create(score: "80")
      becky_exam = Grade.create(score: "50")
      chaz_report = Grade.create(score: "79")
      chaz_essay = Grade.create(score: "55")
      chaz_exam = Grade.create(score: "105")
      report.grades << [becky_report, chaz_report]
      report.save
      essay.grades << [becky_essay, chaz_essay]
      essay.save
      exam.grades << [becky_exam, chaz_exam]
      exam.save
      becky.grades << [becky_exam, becky_report, becky_essay]
      becky.save
      chaz.grades << [chaz_exam, chaz_report, chaz_essay]
      chaz.save
    end

    it 'allows user to change name of course' do

    end

    it 'allows user to add and remove students' do

    end

    it 'allows user to add and remove assessments' do

    end

    it 'allows user to delete the course' do

    end

    it 'is not visible to student users' do

    end
  end
end
