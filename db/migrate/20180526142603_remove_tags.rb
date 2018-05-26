class RemoveTags < ActiveRecord::Migration[5.1]
  def up
    remove_column :pins, :tags
    remove_column :assortments, :tags
  end

  def down
    add_column :pins, :tags, :jsonb, default: [], null: false
    add_column :assortments, :tags, :jsonb, default: [], null: false
  end
end
