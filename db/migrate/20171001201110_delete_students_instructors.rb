class DeleteStudentsInstructors < ActiveRecord::Migration[5.1]
  def change
    drop_table :course_students
    remove_column :courses, :instructor_id
    remove_column :grades, :student_id
    drop_table :instructors
    drop_table :students
  end
end
