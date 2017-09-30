require 'spec_helper'

describe ApplicationController do
  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome!")
    end

    it 'has option to login or signup as an instructor or student' do
      get '/'
      expect(last_response.body).to include("Student")
      expect(last_response.body).to include("Instructor")
    end
  end

  describe "Instructor Signup" do
    it 'loads the signup page' do
      get '/instructor/signup' do
        expect(last_response.status).to eq(200)
      end
    end

    it 'does not let a user sign up without a name, email, and password' do
      params = {name: "", email: "test@test.edu", password: "1234"}
      post '/instructor/signup', params
      expect(last_response.location).to include('/instructor/signup')
    end

    it 'redirects you to courses index' do
      params = {name: "Doc Brown", email: "doc@test.edu", password: "1234"}
      post '/instructor/signup', params
      expect(last_response.location).to include("/courses")
    end
  end

  describe "Instructor Login" do
    it 'loads the login page' do
      get '/instructor/login'
      expect(last_response.status).to eq(200)
    end

    it 'redirects to course index after login' do
      user = Instructor.create(name: "Charles", email: "c@college.edu", password: "1234")
      params = {email: "c@college.edu", password: "1234"}
      post '/instructor/login', params
      expect(last_response.location).to include("/courses")
    end

    it 'does not allow you to login with an incorrect password' do
      user = Instructor.create(name: "Charles", email: "c@college.edu", password: "1234")
      params = {email: "c@college.edu", password: "test"}
      post '/instructor/login', params
      expect(last_response.location).to include("/instructor/login")
    end

    it 'does not allow you to login with an unregistered email' do
      params = {email: "test@college.edu", password: "test"}
      post '/instructor/login', params
      expect(last_response.location).to include("/instructor/login")
    end
  end

  describe "User Logout" do
    it 'lets an instructor log out if they are logged in'  do
      user = Instructor.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/instructor/login', params
      get '/logout'
      expect(last_response.location).to include("/")
    end
  end

  describe "Courses Index" do
    before do
      @user = Instructor.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      course1 = Course.create(name: "Physics 115")
      course2 = Course.create(name: "Art History 101")
      @user.courses. << [course1, course2]
      @user.save
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/instructor/login', params
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

    it 'has a link to add a new course' do
      get '/courses'
      expect(last_response.body).to include("<a href=\"/courses/new\"")
    end

    it 'can only be viewed if logged in' do
      get '/logout'
      get '/courses/new'
      expect(last_response.location).to include("/")
    end
  end

  describe "New Course Form" do
    before do
      @user = Instructor.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/instructor/login', params
    end

    it 'has a form to add a new course' do
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

    it 'creates a new instance of student for each student entered into the roster' do
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
      expect(Course.find_by(name: "Beginner Painting").students.count).to eq(3)
    end

    it 'can only be viewed if logged in' do
      get '/logout'
      get '/courses/new'
      expect(last_response.location).to include("/")
    end
  end

  describe "Course Show Page" do
    before do
      @course = Course.create(name: "Photography")
      leigh = Student.create(name: "Leigh", email: "leigh@test.edu", password: "Leigh")
      becky = Student.create(name: "Becky", email: "becky@test.edu", password: "Becky")
      chaz = Student.create(name: "Chaz", email: "chaz@test.edu", password: "Chaz")
      report = Assessment.create(name: "Report")
      essay = Assessment.create(name: "Essay")
      exam = Assessment.create(name: "Final Exam")
      leigh.build_grade = (course_id: report.id, score: "95")
      leigh.build_grade = (course_id: essay.id, score: "68")
      leigh.build_grade = (course_id: exam.id, score: "100")
      becky.build_grade = (course_id: report.id, score: "75")
      becky.build_grade = (course_id: essay.id, score: "80")
      becky.build_grade = (course_id: exam.id, score: "50")
      chaz.build_grade = (course_id: report.id, score: "79")
      chaz.build_grade = (course_id: essay.id, score: "55")
      chaz.build_grade = (course_id: exam.id, score: "105")
      @course.students << [leigh, becky, chaz]
      @course.assessments << [report, essay, exam]
      @course.save
    end

    it 'displays the course name, student roster, assigments, and student grades' do
      get "/courses/#{@course.slug}"
      expect(last_response.body).to include("Photography")
      expect(last_response.body).to include("Becky")
      expect(last_response.body).to include("Essay")
      expect(last_response.body).to include("<table>")
    end
  end
end

#tests to add when building out the student features
  # student cannot access the add/edit course forms
  # student does not see any links to edit/add forms
