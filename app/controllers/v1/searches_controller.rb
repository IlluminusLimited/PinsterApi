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
    end

    api :GET, '/v1/search/pins', 'Search pins'
    param :published, %w[true false all], default: true, required: false, desc: "Token must have publish:pin"
    param :page, Hash, required: false do
      param :size, String, default: 25
    end

    def pins
      @pins = paginate(PinPolicy::Scope.new(current_user,
                                            params[:published],
                                            Pin.simple_search(params[:query])
                                                .includes(:images))
                           .resolve)
      authorize @pins, :index?
      render 'v1/pins/index'
    end
  end
end
