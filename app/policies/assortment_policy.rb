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
    user.can?('create:assortment')
  end

  def update?
    user.can?('update:assortment')
  end

  def destroy?
    user.can?('destroy:assortment')
  end
end
