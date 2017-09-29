class Student < ActiveRecord::Base
  has_secure_password

  has_many :course_students
  has_many :courses, through: :course_students
  has_many :instructor_students
  has_many :instructors, through: :instructor_students
  has_many :assessments
end
