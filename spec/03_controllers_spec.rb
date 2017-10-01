require 'spec_helper'

describe ApplicationController do
  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome!")
    end

    it 'has links to login or signup' do
      get '/'
      expect(last_response.body).to include("Login")
      expect(last_response.body).to include("Signup")
    end
  end

  describe "Signup" do
    it 'loads the signup page' do
      get '/signup' do
        expect(last_response.status).to eq(200)
      end
    end

    it 'does not let a user sign up without a name, email, and password' do
      params = {name: "", email: "test@test.edu", password: "1234"}
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'has option to choose to sign up as a student or instructor' do
      get '/signup'
      expect(last_response.body).to include("<input type=\"checkbox\" value=\"Instructor\"")
      expect(last_response.body).to include("<input type=\"checkbox\" value=\"Student\"")
    end

    it 'redirects you to courses index' do
      params = {name: "Doc Brown", email: "doc@test.edu", password: "1234"}
      post '/signup', params
      expect(last_response.location).to include("/courses")
    end
  end

  describe "Login" do
    before do
      @user = User.create(name: "Charles", email: "c@college.edu", password: "1234")
    end
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'redirects to course index after login' do
      params = {email: "c@college.edu", password: "1234"}
      post '/login', params
      expect(last_response.location).to include("/courses")
    end

    it 'does not allow you to login with an incorrect password' do
      params = {email: "c@college.edu", password: "test"}
      post '/login', params
      expect(last_response.location).to include("/login")
    end

    it 'does not allow you to login with an unregistered email' do
      params = {email: "test@college.edu", password: "test"}
      post '/login', params
      expect(last_response.location).to include("/login")
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
end

#tests to add when building out the student features
  # student cannot access the add/edit course forms
  # student does not see any links to edit/add forms
