# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :collection

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def index?
    user&.admin?
  end

  def show?
    true
  end

  def update?
    user&.admin? or user&.owns?(collection)
  end

  def destroy?
    user&.admin?
  end
end
