class Assessment < ActiveRecord::Base
  belongs_to :course
  has_many :grades

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
