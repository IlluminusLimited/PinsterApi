# frozen_string_literal: true

class SorceryExternal < ActiveRecord::Migration[5.1]
  def up
    create_table :authentications, id: :uuid do |t|
      t.belongs_to :user,  null: false, index: true, type: :uuid
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token, default: ''

      t.datetime :token_expires_at
      t.timestamps null: false
    end
    add_index :authentications, %i[provider uid]
    add_index :authentications, :token, unique: true
  end

  def down
    remove_index :authentications, name: 'index_authentications_on_provider_and_uid'
    remove_index :authentications, :token
    drop_table :authentications
  end
end
