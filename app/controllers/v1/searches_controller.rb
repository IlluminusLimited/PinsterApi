# frozen_string_literal: true

module V1
  class SearchesController < ApplicationController
    after_action :verify_authorized, except: %i[index pins]

    api :GET, '/v1/search', "Show search results for query"
    param :query, String, allow_nil: false
    param :with_unpublished, :bool, default: false, required: false, desc: "Token must have publish:pin"
    param :page, Hash, required: false do
      param :size, String, default: 60
    end

    def index
      @search = paginate PgSearch.multisearch(params[:query]).includes(searchable: :images)
    end

    def pins
      @pins = paginate Pin.simple_search(params[:query]).includes(:images).where(published: true)
      render 'v1/pins/index'
    end
  end
end
