class AddDueDateColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :due_date, :date, after: :description
  end
end