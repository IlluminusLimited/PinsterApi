# frozen_string_literal: true

module V1
  class SearchesController < ApplicationController
    after_action :verify_authorized, except: %i[index]

    api :GET, '/v1/search', "Show search results for query"
    param :query, String, allow_nil: false
    param :with_unpublished, :bool, default: false, required: false, desc: "Token must have publish:pin"
    param :page, Hash, required: false do
      param :size, String, default: 60
    end

    def index
      @search = paginate PgSearch.multisearch(params[:query]).includes(searchable: :images)

      # @search = paginate(SearchPolicy::Scope.new(
      #     current_user,
      #     params[:with_unpublished],
      #     PgSearch.multisearch(params[:query]).includes(searchable: :images)
      # ).resolve)
    end
  end
end
