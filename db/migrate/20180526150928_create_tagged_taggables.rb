class CreateTaggedTaggables < ActiveRecord::Migration[5.1]
  def change
    create_table :tagged_taggables, id: :uuid do |t|
      t.references :tag, foreign_key: true, type: :uuid
      t.references :taggable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
