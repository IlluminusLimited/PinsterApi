# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections, id: :uuid do |t|
      t.belongs_to :user, index: true, type: :uuid
      t.string :name, null: false
      t.text :description
      t.boolean :public, null: false, default: true
      t.timestamps
    end
  end
end
