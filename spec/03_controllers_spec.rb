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
    before do
      Role.find_or_create_by(name: "Student")
      Role.find_or_create_by(name: "Instructor")
    end

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
      expect(last_response.body).to include("<input type=\"radio\" value=\"#{Role.find_by(name: "Instructor").id}\"")
      expect(last_response.body).to include("<input type=\"radio\" value=\"#{Role.find_by(name: "Student").id}\"")
    end

    it 'redirects you to courses index' do
      params = {name: "Doc Brown", email: "doc@test.edu", password: "1234", role_id: "2"}
      post '/signup', params
      expect(last_response.location).to include("/courses")
    end

    it 'creates a user with a role' do
      Role.find_or_create_by(name: "Student")
      Role.find_or_create_by(name: "Instructor")
      #params = {name: "Doc Brown", email: "doc@test.edu", password: "1234"}
      visit '/signup'
      fill_in :name, :with => "Indiana Jones"
      fill_in :email, :with => "indy@email.com"
      fill_in :password, :with => "1234"
      page.choose 'role_2'
      click_button 'submit'

      expect(User.find_by(name: "Indiana Jones").role.id).to eq(2)
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

  describe "Logout" do
    it 'lets an user log out if they are logged in'  do
      user = User.create(name: "Leigh", email: "leigh@leigh.com", password: "1234")
      params = {email: "leigh@leigh.com", password: "1234"}
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/")
    end
  end
end

#tests to add when building out the student features
  # student cannot access the add/edit course forms
  # student does not see any links to edit/add forms
