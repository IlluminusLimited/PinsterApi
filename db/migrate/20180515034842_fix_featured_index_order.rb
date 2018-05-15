# frozen_string_literal: true

class FixFeaturedIndexOrder < ActiveRecord::Migration[5.1]
  def up
    remove_index :images, :featured
    add_index :images, :featured, order: :desc
  end

  def down
    add_index :images, :featured
  end
end
