# frozen_string_literal: true

class SearchPolicy < ApplicationPolicy
  attr_reader :user, :searchable

  def initialize(user, searchable)
    @user = user
    @searchable = searchable
  end

  def index?
    true
  end

  class Scope < Scope
    attr_reader :current_user, :with_unpublished, :scope

    def initialize(current_user, with_unpublished, scope)
      @current_user = current_user
      @with_unpublished = with_unpublished
      @scope = scope
    end

    def resolve
      return scope if current_user.can?('publish:pin') && with_unpublished

      scope.where('searchables.published = true')
    end
  end
end
