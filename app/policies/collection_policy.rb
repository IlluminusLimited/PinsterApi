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

  def show?
    user.admin? or collection.public? or user.owns?(collection)
  end

  def create?
    user.user?
  end

  def update?
    user.admin? or user.owns?(collection)
  end

  def destroy?
    user.admin? or user.owns?(collection)
  end

  def permitted_attributes
    if user.admin?
      [:name, :description, :public, :user_id,
       collectable_collections_attributes: CollectableCollection.public_attribute_names]
    else
      [:name, :description,
       collectable_collections_attributes: CollectableCollection.public_attribute_names]
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
      return scope.where(user_id: collection_user_id) if current_user&.admin? || current_user.id == collection_user_id
      scope.where(user_id: collection_user_id, public: true)
    end
  end
end
