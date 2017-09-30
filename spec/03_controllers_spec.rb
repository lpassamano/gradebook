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
      expect(last_response.body).to include("<a href=/courses")
    end
  end
end
