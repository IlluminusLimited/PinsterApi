# frozen_string_literal: true

class AddTagsToPin < ActiveRecord::Migration[5.1]
  def up
    add_column :pins, :tags, :jsonb, default: {}, null: false
  end

  def down
    remove_column :pins, :tags
  end
end
