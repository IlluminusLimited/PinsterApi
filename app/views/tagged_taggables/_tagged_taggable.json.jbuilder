json.extract! tagged_taggable, :id, :tag_id, :taggable_id, :taggable_type, :created_at, :updated_at
json.url tagged_taggable_url(tagged_taggable, format: :json)
