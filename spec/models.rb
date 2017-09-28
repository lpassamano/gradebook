require 'spec_helper'

describe Instructor do
  before do
    @instructor = Instructor.new(name: "test", email: "test@test.edu", password: "1234")
  end

  it 'an new instructor is instantiated with a name' do
    expect(@user.name).to eq("test")
  end

  it 'an new instructor is instantiated with a email' do
    expect(@user.email).to eq("test@test.edu")
  end

  it 'an new instructor is instantiated with a password' do
    expect(@user.password).to eq("1234")
  end
  #initialize w/ name, email, password
  #slugifiable
  #has secure password

end
