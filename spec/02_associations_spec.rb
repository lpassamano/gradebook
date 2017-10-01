require 'spec_helper'

describe 'User Associations' do
  before do
    @user = User.create(name: "Charles", email: "c@test.edu", password: "1234")
  end

  it 'has many courses' do
    math = Course.create(name: "Math")
    chem = Course.create(name: "Chemistry")
    @user.courses << [math, chem]

    expect(User.find_by(name: "Charles").courses.count).to eq(2)
  end

  it 'belongs to a role' do

  end

  it 'has many grades' do

  end
end

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

  it 'has many grades' do
    exam = Grade.create(score: "95")
    project = Grade.create(score: "50")
    @student.grades << [exam, project]

    expect(Student.find_by(name: "Leigh").grades.count).to eq(2)
  end
end

describe 'Assessment Associations' do
  before do
    @assessment = Assessment.create(name: "Book Report")
  end

  it 'belongs to an course' do
    physics = Course.create(name: "Physics")
    @assessment.course = physics
    @assessment.save

    expect(Assessment.find_by(name: "Book Report").course).to eq(physics)
  end

  it 'has many grades' do
    x = Grade.create
    y = Grade.create
    z = Grade.create
    @assessment.grades << [x, y, z]
    @assessment.save

    expect(Assessment.find_by(name: "Book Report").grades.count).to eq(3)
  end
end

describe "Grade Associations" do
  before do
    @grade = Grade.create(score: "100")
  end

  it 'belongs to a student' do
    leigh = Student.create(name: "Leigh", password: "1234")
    @grade.student = leigh
    @grade.save

    expect(Grade.find_by(score: "100").student).to eq(leigh)
  end

  it 'belongs to an assessment' do
    exam = Assessment.create
    @grade.assessment = exam
    @grade.save

    expect(Grade.find_by(score: "100").assessment).to eq(exam)
  end
end
