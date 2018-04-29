# frozen_string_literal: true

class MePolicy < ApplicationPolicy
  attr_reader :user, :collection

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def show?
    user&.admin? or collection.public? or user&.owns?(collection)
  end

  def update?
    user&.admin? or user&.owns?(collection)
  end
end
