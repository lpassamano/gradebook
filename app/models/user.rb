class User < ActiveRecord::Base
  has_secure_password

  belongs_to :role 
  has_many :course_students
  has_many :courses, through: :course_students
  has_many :grades
end
