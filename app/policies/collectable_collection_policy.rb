# frozen_string_literal: true

class CollectableCollectionPolicy < ApplicationPolicy
  attr_reader :user, :collectable_collection

  def initialize(user, collectable_collection)
    @user = user
    @collectable_collection = collectable_collection
  end

  def index?
    user.admin? or user.user?
  end

  def show?
    user.admin? or collectable_collection.collection.public? or user.owns?(collectable_collection.collection)
  end

  def create?
    user.user?
  end

  def update?
    user.admin? or user.owns?(collectable_collection.collection)
  end

  def destroy?
    user.admin? or user.owns?(collectable_collection.collection)
  end
end
