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
    if user.admin?
      Image.public_attribute_names
    else
      %i[description featured name]
    end
  end
end
