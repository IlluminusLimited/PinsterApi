# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :display_name
      t.text :bio
      t.datetime :verified
      t.integer :role, null: false, default: 3

      t.timestamps
    end
    add_index :users, :email, unique: true
  end

  def down
    remove_index :users, :email
    drop_table :users
  end
end
