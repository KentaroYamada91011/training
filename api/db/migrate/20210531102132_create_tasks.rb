class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id,          null: false,  default: 1
      t.string :title,             null: false
      t.string :description,         null: false,  default: ""
      t.datetime :deadline,        null: false,  default: "9999-12-31 23:59:59"
      t.integer :status,           null: false,  default: 10
      t.integer :parent_id,        null: false,  default: 0

      t.timestamps
    end
  end
end
