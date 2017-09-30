class DropInstructorStudents < ActiveRecord::Migration[5.1]
  def change
    drop_table :instructor_students
  end
end
