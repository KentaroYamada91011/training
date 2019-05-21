class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: 1, limit: 1, unsigned: true

      t.timestamps
    end
  end
end
