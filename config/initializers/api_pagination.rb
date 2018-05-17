# frozen_string_literal: true

ApiPagination.configure do |config|
  config.paginator = :kaminari
  config.total_header = 'X-Total'
  config.per_page_header = 'X-Page-Size'
  config.page_header = 'X-Page'
  config.page_param = :page
  config.per_page_param = :page_size
end
