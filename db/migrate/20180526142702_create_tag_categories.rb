class CreateTagCategories < ActiveRecord::Migration[5.1]
  def up
    create_table :tag_categories, id: :uuid do |t|
      t.uuid :tag_id
      t.uuid :category_id

      t.timestamps
    end
    add_index :tag_categories, [:category_id, :tag_id], unique: true
  end

  def down
    remove_index :tag_categories, [:category_id, :tag_id], unique: true
    drop_table :tag_categories
  end
end
