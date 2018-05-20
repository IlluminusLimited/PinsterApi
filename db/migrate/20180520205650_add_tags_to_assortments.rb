# frozen_string_literal: true

class AddTagsToAssortments < ActiveRecord::Migration[5.1]
  def up
    add_column :assortments, :tags, :jsonb, default: [], null: false
  end

  def down
    remove_column :assortments, :tags
  end
end
