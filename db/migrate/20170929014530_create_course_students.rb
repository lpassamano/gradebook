class CreateCourseStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :course_students do |t|
      t.integer :course_id
      t.integer :student_id 
    end
  end
end
