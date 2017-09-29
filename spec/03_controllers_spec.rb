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
      expect(last_response.location).to include("/instructor/courses")
    end
  end

end
