# frozen_string_literal: true

class ImagePolicy < ApplicationPolicy
  attr_reader :user, :image

  def initialize(user, image)
    @user = user
    @image = image
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.moderator?
  end

  def update?
    user.moderator?
  end

  def destroy?
    user.moderator?
  end

  def permitted_attributes
    if user.moderator?
      %i[name base_file_name description featured imageable_type name storage_location_uri imageable_id]
    else
      %i[name description name]
    end
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
