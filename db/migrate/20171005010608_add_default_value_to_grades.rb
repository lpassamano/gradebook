class AddDefaultValueToGrades < ActiveRecord::Migration[5.1]
  def change
    change_column :grades, :score, :string, :default => "-"
  end
end
