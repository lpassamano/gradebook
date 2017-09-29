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
    report = Assessment.create(name: "Report")
    essay = Assessment.create(name: "Essay")
    exam = Assessment.create(name: "Final Exam")
    @course.assessments << [report, essay, exam]
    @course.save

    expect(Course.find_by(name: "Test Course").assessments.include?(exam)).to eq(true)
  end
end

describe 'Instructor Associations' do
  before do
    @instructor = Instructor.create(name: "Charles", email: "c@test.edu", password: "1234")
  end

  it 'has many courses' do
    math = Course.create(name: "Math")
    chem = Course.create(name: "Chemistry")
    @instructor.courses << [math, chem]
    @instructor.save

    expect(Instructor.find_by(name: "Charles").courses.count).to eq(2)
  end

  it 'has many students' do
    sam = Student.create(name: "Sam", email: "s@test.edu", password: "1234")
    bob = Student.create(name: "Bob", email: "b@test.edu", password: "abcd")
    @instructor.students << [sam, bob]
    @instructor.save

    expect(Instructor.find_by(name: "Charles").students.include?(sam)).to eq(true)
  end
end

describe "Student Associations" do
  before do
    @student = Student.create(name: "Leigh", email: "l@test.edu", password: "1234")
  end

  it 'has many courses' do
    art = Course.create(name: "Art")
    music = Course.create(name: "Music")
    @student.courses << [art, music]
    @student.save

    expect(Student.find_by(name: "Leigh").courses.include?(art)).to eq(true)
  end

  it 'has many assessments' do
    exam = Assessment.create(name: "Final Exam")
    project = Assessment.create(name: "Group Project")
    @student.assessments << [exam, project]

    expect(Student.find_by(name: "Leigh").assessments.count).to eq(2)
  end
end

describe 'Assessment Associations' do
  before do
    @assessment = Assessment.create(name: "Book Report")
  end

  it 'belongs to an instructor' do
    leigh = Instructor.create(name: "Leigh", password: "1234")
    @assessment.instructor = leigh

    expect(Assessment.find_by(name: "Book Report").instructor).to eq(leigh)
  end

  it 'belongs to a student' do
    julia = Student.create(name: "Julia", password: "asdf")
    @assessment.student = julia

    expect(Assessment.find_by(name: "Book Report").student).to eq(julia)
  end
end
