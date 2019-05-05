# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :user_to_be_modified

  def initialize(user, user_to_be_modified)
    @user = user
    @user_to_be_modified = user_to_be_modified
  end

  def index?
    user.can?('index:user')
  end

  def show?
    true
  end

  def update?
    user.can?('update:user') or (user.user? and user.id == user_to_be_modified.id)
  end

  def destroy?
    user.can?('destroy:user')
  end

  def permitted_attributes
    if user.can?('update:user')
      %i[bio display_name verified]
    else
      %i[bio display_name]
    end
  end
end
