class CreateCategories < ActiveRecord::Migration[5.1]
  def up
    create_table :categories, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end

  def down
    remove_index :categories, :name, unique: true
    drop_table :categories
  end
end
