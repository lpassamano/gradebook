require 'spec_helper'

describe 'User Associations' do
  before do
    @user = User.create(name: "Charles", email: "c@test.edu", password: "1234")
  end

  it 'has many courses' do
    math = Course.create(name: "Math")
    chem = Course.create(name: "Chemistry")
    @user.courses << [math, chem]
    @user.save

    expect(User.find_by(name: "Charles").courses.count).to eq(2)
  end

  it 'belongs to a role' do
    role = Role.create(name: "Instructor")
    @user.role = role
    @user.save

    expect(User.find_by(name: "Charles").role).to eq(role)
  end

  it 'has many grades' do
    exam = Grade.create(score: "95")
    project = Grade.create(score: "50")
    @user.grades << [exam, project]

    expect(User.find_by(name: "Charles").grades.count).to eq(2)
  end
end

describe 'Course Associations' do
  before do
    @course = Course.create(name: "Test Course")
  end

  it 'has many users' do
    leigh = User.create(name: "Leigh", email: "leigh@test.edu", password: "5678")
    becky = User.create(name: "Becky", email: "becky@test.edu", password: "asdf")
    @course.users << [leigh, becky]
    @course.save

    expect(Course.find_by(name: "Test Course").users.count).to eq(2)
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

  it 'belongs to a user' do
    leigh = User.create(name: "Leigh", password: "1234")
    @grade.user = leigh
    @grade.save

    expect(Grade.find_by(score: "100").user).to eq(leigh)
  end

  it 'belongs to an assessment' do
    exam = Assessment.create
    @grade.assessment = exam
    @grade.save
    expect(Grade.find_by(score: "100").assessment).to eq(exam)
  end
end
