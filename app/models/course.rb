class Course < ActiveRecord::Base
  belongs_to :instructor
  has_many :course_students
  has_many :students, through: :course_students
  has_many :assessments

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
