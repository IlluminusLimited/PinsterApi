class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :name, null: false
      t.text :description
      t.string :collectable_type
      t.uuid :collectable_id

      t.timestamps
    end
    add_index :collections, :user_id
    add_index :collections, %i[collectable_type collectable_id]
  end
end
