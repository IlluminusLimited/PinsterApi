# frozen_string_literal: true

# https://github.com/Apipie/apipie-rails#documentation
Apipie.configure do |config|
  config.app_name = "PinsterBase"
  config.api_base_url = ""
  config.doc_base_url = "/doc"
  config.api_controllers_matcher = Rails.root.join("app", "controllers", "**", "*.rb")
  config.markup = Apipie::Markup::Markdown.new
  config.translate = false

  config.show_all_examples = 1

  # TODO: Get markdown parser to build this description.
  config.app_info = <<-END_OF_INFO
  Welcome to the Pinster API Docs!

  These resources are automatically generated and can sometimes be slightly different than the real thing.

  Things to Note:
    The IDs represented in the examples are samples. In practice, the IDs used are UUIDs.
  END_OF_INFO

  # Swagger settings for latest version of apipie (unreleased)
  # config.swagger_content_type_input = :json
  # config.swagger_json_input_uses_refs = true
  # config.swagger_include_warning_tags = true
  # config.swagger_suppress_warnings = false
end
