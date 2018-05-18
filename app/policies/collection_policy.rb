# frozen_string_literal: true

class CollectionPolicy < ApplicationPolicy
  attr_reader :user, :collection

  def initialize(_user, collection)
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
    attr_reader :user, :scope

    def initialize(_user, scope)
      @user = _user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
