# frozen_string_literal: true

class AddPublished < ActiveRecord::Migration[5.2]
  def up
    add_column :assortments, :published, :boolean, default: false, null: false
    add_column :pins, :published, :boolean, default: false, null: false
    Pin.update_all(published: true)
  end

  def down
    remove_column :assortments, :published, :boolean, default: false, null: false
    remove_column :pins, :published, :boolean, default: false, null: false
  end
end
