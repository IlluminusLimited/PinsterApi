# frozen_string_literal: true

json.oauth_providers do
  json.google auth_at_provider_url(:google)
  json.facebook auth_at_provider_url(:facebook)
end
