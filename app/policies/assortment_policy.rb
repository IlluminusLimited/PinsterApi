# frozen_string_literal: true

class AssortmentPolicy < ApplicationPolicy
  attr_reader :user, :assortment

  def initialize(user, assortment)
    @user = user
    @assortment = assortment
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.moderator?
  end

  def update?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end

  class Scope
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
