class CreateTagCategories < ActiveRecord::Migration[5.1]
  def up
    create_table :tag_categories, id: :uuid do |t|
      t.references :tag, foreign_key: true, type: :uuid
      t.references :category, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :tag_categories, [:category_id, :tag_id], unique: true
  end

  def down
    remove_index :tag_categories, [:category_id, :tag_id], unique: true
    drop_table :tag_categories
  end
end
