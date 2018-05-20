# frozen_string_literal: true

class CollectableCollectionPolicy < ApplicationPolicy
  attr_reader :user, :collectable_collection

  def initialize(user, collectable_collection)
    @user = user
    @collectable_collection = collectable_collection
  end

  def index?
    true
  end

  def show?
    user.admin? or collectable_collection.collection.public? or user.owns?(collectable_collection.collection)
  end

  def create?
    user.admin? or (user.user? and user.owns?(collectable_collection.collection))
  end

  def update?
    user.admin? or user.owns?(collectable_collection.collection)
  end

  def destroy?
    user.admin? or user.owns?(collectable_collection.collection)
  end
end
