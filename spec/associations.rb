require 'spec_helper'

describe 'Course Associations' do
  before do
    @course = Course.create(name: "Test Course")
  end

  it 'belongs to instructor' do
    instructor = Instructor.create(name: "Person", email: "p@test.edu", password: "1234")
    @course.instructor = instructor
    @course.save

    expect(Course.find_by(name: "Test Course").instructor).to eq(instructor)
  end

  it 'has many students' do

  end

  it 'has many assessments' do

  end
end

#instructor has many courses
