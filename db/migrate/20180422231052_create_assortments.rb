# frozen_string_literal: true

class CreateAssortments < ActiveRecord::Migration[5.1]
  def change
    create_table :assortments, id: :uuid do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
