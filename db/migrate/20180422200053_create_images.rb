# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.string :imageable_type
      t.uuid :imageable_id
      t.string :name
      t.text :description
      t.text :storage_location_uri, null: false
      t.text :base_file_name, null: false
      t.datetime :featured

      t.timestamps
    end
    add_index :images, :featured
    add_index :images, %i[imageable_type imageable_id]
  end
end
