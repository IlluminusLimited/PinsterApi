class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name, index: true, unique: true

      t.timestamps
    end
  end
end
