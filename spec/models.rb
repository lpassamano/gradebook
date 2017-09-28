require 'spec_helper'

describe Instructor do
  before do
    @instructor = Instructor.create(name: "test", email: "test@test.edu", password: "1234")
  end

  it 'is instantiated with a name' do
    expect(@instructor.name).to eq("test")
  end

  it 'is instantiated with a email' do
    expect(@instructor.email).to eq("test@test.edu")
  end

  it 'is instantiated with a password' do
    expect(@instructor.password).to eq("1234")
  end

  it 'has a secure password' do
    expect(@instructor.authenticate("test")).to eq(false)
    expect(@instructor.authenticate("1234")).to eq(@instructor)
  end
  # slugifiable?
end
