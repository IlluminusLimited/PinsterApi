# frozen_string_literal: true

module V1
  class SearchesController < ApplicationController
    after_action :verify_authorized, except: %i[index]

    api :GET, '/v1/search', "Show search results for query"
    param :query, String, allow_nil: false
    param :page, Hash, required: false do
      param :size, String, default: 60
    end

    def index
      @search = paginate PgSearch.multisearch(params[:query]).includes(searchable: :images)
    end
  end
end
