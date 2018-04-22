# frozen_string_literal: true

class CreatePins < ActiveRecord::Migration[5.1]
  def change
    create_table :pins, id: :uuid do |t|
      t.string :name, null: false
      t.integer :year
      t.text :description

      t.timestamps
    end
  end
end
