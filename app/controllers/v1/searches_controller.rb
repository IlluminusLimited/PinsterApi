# frozen_string_literal: true

module V1
  class SearchesController < ApplicationController
    after_action :verify_authorized, except: %i[index]

    api :GET, '/v1/searches', "Show searches results for query"
    param :query, String, allow_nil: false
    def index
      @search = paginate PgSearch.multisearch(params[:query])
    end
  end
end
