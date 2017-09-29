class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.string :score
      t.string :comment
      t.integer :assessment_id
      t.integer :student_id 
    end
  end
end
