
# frozen_string_literal: true

json.extract! search, :id, :content, :searchable_type, :searchable_id, :created_at, :updated_at
json.url polymorphic_url([:v1, search.searchable])
