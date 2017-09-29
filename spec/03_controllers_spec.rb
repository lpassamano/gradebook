require 'spec_helper'

describe ApplicationController do
  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome!")
    end
  end

  describe "Signup" do
    it 'loads the signup page' do
      get '/signup' do
        expect(last_response.status).to eq(200)
      end
    end

    it 'does not let a user sign up without a name, email, and password' do
      #check params for name, email, password 
    end

    it 'requires that you use your school/university email to signup' do
      #use regex to make sure email ends with .edu
    end
  end

end
