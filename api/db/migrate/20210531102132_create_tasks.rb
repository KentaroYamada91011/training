class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id,          null: false
      t.string :title,             null: false
      t.text :description,         null: false
      t.datetime :deadline,        null: false
      t.integer :status,           null: false
      t.integer :parent_id,        null: false

      t.timestamps
    end
  end
end
