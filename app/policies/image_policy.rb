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
    user.can?('create:image')
  end

  def update?
    user.can?('update:image')
  end

  def destroy?
    user.can?('destroy:image')
  end
end
