class ChangeColumnToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :title, :string, limit: 30
    add_index :tasks, :title
  end
end