class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.references :imageable, polymorphic: true
      t.string :name, null: false
      t.text :description
      t.text :storage_location_uri, null: false
      t.datetime :featured

      t.timestamps
    end
    add_index :images, :featured
  end
end
