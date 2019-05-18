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
    user.can?('show:collectable_collection') or collectable_collection.collection.public? \
      or user.owns?(collectable_collection.collection)
  end

  def create?
    user.can?('create:collectable_collection') or (user.user? and user.owns?(collectable_collection.collection))
  end

  def update?
    user.can?('update:collectable_collection') or user.owns?(collectable_collection.collection)
  end

  def destroy?
    user.can?('destroy:collectable_collection') or user.owns?(collectable_collection.collection)
  end

  def permitted_attributes_for_update
    if user.can?('update:collectable_collection')
      CollectableCollection.all_attribute_names
    else
      CollectableCollection.public_attribute_names
    end
  end

  def permitted_attributes_for_create
    CollectableCollection.all_attribute_names
  end
end
