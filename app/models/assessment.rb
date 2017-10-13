class Assessment < ActiveRecord::Base
  belongs_to :course
  has_many :grades
  has_many :users, through: :grades

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
