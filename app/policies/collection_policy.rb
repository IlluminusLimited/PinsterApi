# frozen_string_literal: true

class CollectionPolicy < ApplicationPolicy
  attr_reader :user, :collection

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def index?
    true
  end

  def summary?
    true
  end

  def show?
    user.can?('show:collection') or collection.public? or user.owns?(collection)
  end

  def create?
    user.user?
  end

  def update?
    user.can?('update:collection') or user.owns?(collection)
  end

  def destroy?
    user.can?('destroy:collection') or user.owns?(collection)
  end

  def permitted_attributes
    if user.can?('update:collection')
      Collection.all_attribute_names
    else
      Collection.public_attribute_names
    end
  end

  class Scope < Scope
    attr_reader :current_user, :collection_user_id, :scope

    def initialize(current_user, collection_user_id, scope)
      @current_user = current_user
      @collection_user_id = collection_user_id
      @scope = scope
    end

    def resolve
      if current_user.can?('show:collections') or current_user.id == collection_user_id
        return scope.where(user_id: collection_user_id)
      end

      scope.where(user_id: collection_user_id, public: true)
    end
  end
end
