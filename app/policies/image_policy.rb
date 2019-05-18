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
    user.can?('create:image') or (user.user? and user.owns?(imageable))
  end

  def update?
    user.can?('update:image') or (user.user? and user.owns?(imageable))
  end

  def destroy?
    user.can?('destroy:image') or (user.user? and user.owns?(imageable))
  end

  def permitted_attributes
    if user.can?('update:image')
      Image.all_attribute_names
    else
      Image.public_attribute_names
    end
  end

  private

    def imageable
      return false unless image.respond_to?(:imageable)

      image.imageable
    end
end
