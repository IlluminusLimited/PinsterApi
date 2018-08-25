# frozen_string_literal: true

class AddCounterCacheForImageables < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    add_column :collectable_collections, :images_count, :integer, default: 0, null: false
    add_column :collections, :images_count, :integer, default: 0, null: false
    add_column :assortments, :images_count, :integer, default: 0, null: false
    add_column :users, :images_count, :integer, default: 0, null: false
    add_column :pins, :images_count, :integer, default: 0, null: false

    add_index :collectable_collections, :images_count, algorithm: :concurrently
    add_index :collections, :images_count, algorithm: :concurrently
    add_index :assortments, :images_count, algorithm: :concurrently
    add_index :users, :images_count, algorithm: :concurrently
    add_index :pins, :images_count, algorithm: :concurrently
  end

  def down
    remove_index :collectable_collections, :images_count
    remove_index :collections, :images_count
    remove_index :assortments, :images_count
    remove_index :users, :images_count
    remove_index :pins, :images_count

    remove_column :collectable_collections, :images_count
    remove_column :collections, :images_count
    remove_column :assortments, :images_count
    remove_column :users, :images_count
    remove_column :pins, :images_count
  end
end
