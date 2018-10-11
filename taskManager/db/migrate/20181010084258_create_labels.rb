class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :label_name

      t.timestamps
    end
    add_index :labels, :label_name, unique: true
  end
end