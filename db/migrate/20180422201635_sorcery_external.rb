# frozen_string_literal: true

class SorceryExternal < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token, default: ''

      t.datetime :token_expires_at
      t.timestamps null: false
    end
    add_index :authentications, :user_id
    add_index :authentications, %i[provider uid]
    add_index :authentications, :token, unique: true
  end
end
