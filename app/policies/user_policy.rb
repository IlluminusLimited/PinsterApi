# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :user_to_be_modified

  def initialize(user, user_to_be_modified)
    @user = user
    @user_to_be_modified = user_to_be_modified
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    user.admin? or (user.user? and user.id == user_to_be_modified.id)
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      %i[bio display_name email role verified]
    else
      %i[bio display_name email]
    end
  end
end
