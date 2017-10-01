class User < ActiveRecord::Base
  has_secure_password

  belongs_to :role
  has_many :user_courses 
  has_many :courses, through: :user_courses
  has_many :grades
end
