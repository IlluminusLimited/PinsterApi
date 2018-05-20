# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.belongs_to :imageable, polymorphic: true, index: true, type: :uuid
      t.string :name
      t.text :description
      t.text :storage_location_uri, null: false
      t.text :base_file_name, null: false
      t.datetime :featured
      t.boolean :thumbnailable, null: false, default: true

      t.timestamps
    end
    add_index :images, :featured, order: :desc
  end
end
