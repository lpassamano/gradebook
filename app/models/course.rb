class Course < ActiveRecord::Base
  belongs_to :instructor, class_name: "User", foreign_key: "instructor_id"
  has_many :user_courses
  has_many :users, through: :user_courses
  has_many :assessments

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
