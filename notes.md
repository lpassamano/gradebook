what I want to be able to do:

class User << ActiveRecord::Base
  #attributes: name, email, password, role_id 
end

class Instructor << User
  def initialize(params)
    user = User.new(params)
    user.role = Role.find_or_create_by(name: "Instructor")
    user.save
  end
end

def Student << User
  def initialize(params)
    user = User.new(params)
    user.role = Role.find_or_create_by(name: "Student")
    user.save
  end
end

schema would only have 1 table for users, with a column for role_id

would this make it so users initialized using Student.new and Instructor.new would be created in the users table?
