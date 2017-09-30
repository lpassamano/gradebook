class EditAssessements < ActiveRecord::Migration[5.1]
  def change
    remove_column :assessments, :grade
    remove_column :assessments, :comment
    remove_column :assessments, :student_id
  end
end
