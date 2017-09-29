class CreateAssessments < ActiveRecord::Migration[5.1]
  def change
    create_table :assessments do |t|
      t.string :name
      t.string :grade
      t.string :comment
      t.integer :course_id
      t.integer :student_id 
    end
  end
end
