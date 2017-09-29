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
    leigh = Student.create(name: "Leigh", email: "leigh@test.edu", password: "5678")
    becky = Student.create(name: "Becky", email: "becky@test.edu", password: "asdf")
    @course.students << [leigh, becky]
    @course.save

    expect(Course.find_by(name: "Test Course").students.count).to eq(2)
  end

  it 'has many assessments' do

  end
end

#instructor has many courses
