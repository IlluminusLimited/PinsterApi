# frozen_string_literal: true

json.extract! search, :id, :content, :searchable_type, :searchable_id, :created_at, :updated_at
if search.association(:searchable).loaded?
  json.searchable do
    json.partial! search.searchable
  end
end
json.url polymorphic_url([:v1, search.searchable])
