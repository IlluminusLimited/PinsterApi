class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections, id: :uuid do |t|
      t.uuid :user_id
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :collections, :user_id
  end
end
