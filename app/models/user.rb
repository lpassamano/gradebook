class User < ActiveRecord::Base
  has_secure_password

  belongs_to :role
  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :grades
  has_many :assessments, through: :grades
  
  def student?
    self.role == Role.find_by(name: "Student")
  end

  def instructor?
    self.role == Role.find_by(name: "Instructor")
  end
end
