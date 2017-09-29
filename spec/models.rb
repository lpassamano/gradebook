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
  # has many courses
  # has may students through courses
end

describe Course do
  before do
    @course = Course.create(name: "Test Class")
  end

  it 'is instantiated with a name' do
    expect(@course.name).to eq("Test Class")
  end

  it 'belongs to an instructor' do
    # some code here
  end
  #has many students
  #slugifiable
end

describe Student do
  before do
    @student = Student.create(name: "Test Testerson", email: "student@test.edu", password: "asdf")
  end

  it 'is instantiated with a name, email, and password' do
    expect(@student.name).to eq("Test Testerson")
    expect(@student.email).to eq("student@test.edu")
    expect(@student.password).to eq("asdf")
  end

  it 'has a secure password' do
    expect(@student.authenticate("test")).to eq(false)
    expect(@student.authenticate("asdf")).to eq(@student)
  end
  #slugifiable
  #has many courses
  #has many assessments
end
