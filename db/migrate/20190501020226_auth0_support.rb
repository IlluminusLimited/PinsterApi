# frozen_string_literal: true

class Auth0Support < ActiveRecord::Migration[5.2]
  def change
    User.destroy_all
    change_table :users, bulk: true do
      drop_table :authentications, id: :uuid do |t|
        t.belongs_to :user, null: false, index: true, type: :uuid
        t.string :provider, null: false
        t.string :uid, null: false
        t.string :token, default: ''

        t.datetime :token_expires_at
        t.timestamps null: false
      end
      remove_index :users, :email
      remove_column :users, :email, :string
      remove_column :users, :role, :integer
      add_column :users, :external_user_id, :text, null: false
      add_index :users, :external_user_id, unique: true
    end
  end
end
