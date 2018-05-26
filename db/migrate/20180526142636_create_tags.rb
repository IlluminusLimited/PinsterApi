class CreateTags < ActiveRecord::Migration[5.1]
  def up
    create_table :tags, id: :uuid do |t|
      t.references :taggable, polymorphic: true, index: true, type: :uuid
      t.string :name

      t.timestamps
    end
    add_index :tags, :name, unique: true
  end

  def down
    remove_index :tags, [:taggable_type, :taggable_id], unique: true
    remove_index :tags, :name, unique: true
    drop_table :tags
  end
end
