class CreateLabels < ActiveRecord::Migration[5.2]
  def up
    create_table :labels do |t|
      t.string :name

      t.index      [:name], unique: true
      t.timestamps
    end
  end
  def down
    drop_table :labels
  end
end
