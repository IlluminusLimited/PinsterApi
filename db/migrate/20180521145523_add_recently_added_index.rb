# frozen_string_literal: true

class AddRecentlyAddedIndex < ActiveRecord::Migration[5.1]
  def up
    add_index :pins, :created_at, order: :desc
    add_index :assortments, :created_at, order: :desc
    add_index :collections, :created_at, order: :desc
  end

  def down
    remove_index :pins, :created_at
    remove_index :assortments, :created_at
  end
end
