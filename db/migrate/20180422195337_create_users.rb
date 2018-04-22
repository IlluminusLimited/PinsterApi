class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :display_name
      t.text :bio
      t.integer :role
      t.datetime :verified

      t.timestamps
    end
  end
end
