class Course < ActiveRecord::Base
  has_many :user_courses
  has_many :users, through: :user_courses 
  has_many :assessments

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
