class Grade < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :user
end
