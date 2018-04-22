class CreateCollectableCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collectable_collections, id: :uuid do |t|
      t.string :collectable_type
      t.uuid :collectable_id
      t.uuid :collection_id

      t.timestamps
    end
    add_index :collectable_collections, %i[collectable_type collectable_id collection_id], unique: true
    add_index :collectable_collections, :collection_id
  end
end
