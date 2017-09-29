class CreateInstructorStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :instructor_students do |t|
      t.integer :instructor_id
      t.integer :student_id 
    end
  end
end
