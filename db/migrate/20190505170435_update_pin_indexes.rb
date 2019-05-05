# frozen_string_literal: true

class UpdatePinIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :pins, name: 'index_pins_on_created_at', column: :created_at, order: :desc
    add_index :pins, %i[year created_at], order: :desc
  end
end
