# frozen_string_literal: true

module V1
  class SearchController < ApplicationController
    after_action :verify_authorized, except: %i[search]

    api :GET, '/v1/search', "Show an imageable's images"
    param :query, String, allow_nil: false
    def search
      @search = PgSearch.multisearch(params[:query]).page(params[:page]).per(params[:page_size])
    end
  end
end
