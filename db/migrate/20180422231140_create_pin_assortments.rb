# frozen_string_literal: true

class CreatePinAssortments < ActiveRecord::Migration[5.1]
  def change
    create_table :pin_assortments, id: :uuid do |t|
      t.belongs_to :pin, index: true, type: :uuid
      t.belongs_to :assortment, index: true, type: :uuid

      t.timestamps
    end
  end
end
