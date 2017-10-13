class Role < ActiveRecord::Base
  has_many :users

  def self.student_id
    @@student_id ||= self.find_by(name: "Student").id
  end

  def self.instructor_id
    @@instructor_id ||= self.find_by(name: "Instructor").id
  end
end
