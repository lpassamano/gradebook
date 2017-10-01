require 'spec_helper'

describe User do
  before do
    @user = User.create(name: "test", email: "test@email.com", password: "1234")
  end

  it "is instantiated with a name, email, and password" do
    expect(@user.name).to eq("test")
    expect(@user.email).to eq("test@email.com")
    expect(@user.password).to eq("1234")
  end

  it 'has a secure password' do
    expect(@user.authenticate("test")).to eq(false)
    expect(@user.authenticate("1234")).to eq(@user)
  end
end

describe Course do
  before do
    @course = Course.create(name: "Test Class")
  end

  it 'is instantiated with a name' do
    expect(@course.name).to eq("Test Class")
  end
  #slugifiable
end

describe Assessment do
  before do
    @assessment = Assessment.create(name: "Final Exam")
  end

  it 'is instantiated with a name' do
    expect(@assessment.name).to eq("Final Exam")
  end
end

describe Grade do
  before do
    @grade = Grade.create(score: "100", comment: "great job!")
  end

  it 'is instantiated with a name and comment' do
    expect(@grade.score).to eq("100")
    expect(@grade.comment).to eq("great job!")
  end
end
