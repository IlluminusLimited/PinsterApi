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

  private

    def imageable
      return false unless image.respond_to?(:imageable)

      image.imageable
    end
  #
  # class Scope < Scope
  #   attr_reader :current_user, :imageable_type, :imageable_id, :scope
  #
  #   def initialize(current_user, imageable_type, imageable_id, scope)
  #     @current_user = current_user
  #     @imageable_type = imageable_type
  #     @imageable_id = imageable_id
  #     @scope = scope
  #   end
  #
  #   def resolve
  #     if current_user.can?('show:collections') || current_user.id == collection_user_id
  #       return scope.where(user_id: collection_user_id)
  #     end
  #
  #     scope.where(user_id: collection_user_id, public: true)
  #   end
  # end
end
