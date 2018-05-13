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
end
