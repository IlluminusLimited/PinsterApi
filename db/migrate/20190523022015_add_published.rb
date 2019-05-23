# frozen_string_literal: true

class AddPublished < ActiveRecord::Migration[5.2]
  def change
    add_column :assortments, :published, :boolean, default: false, null: false
    add_column :pins, :published, :boolean, default: false, null: false
  end
end
