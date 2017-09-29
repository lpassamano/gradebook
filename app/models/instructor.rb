class Instructor < ActiveRecord::Base
  has_secure_password

  has_many :courses
  has_many :instructor_students
  has_many :students, through: :instructor_students
end
