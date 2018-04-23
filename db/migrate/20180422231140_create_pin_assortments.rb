# frozen_string_literal: true

class CreatePinAssortments < ActiveRecord::Migration[5.1]
  def change
    create_table :pin_assortments, id: :uuid do |t|
      t.uuid :pin_id
      t.uuid :assortment_id

      t.timestamps
    end
    add_index :pin_assortments, :assortment_id
  end
end
