# frozen_string_literal: true

class PinPolicy < ApplicationPolicy
  attr_reader :user, :pin

  def initialize(user, pin)
    @user = user
    @pin = pin
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.can?('create:pin')
  end

  def update?
    user.can?('update:pin')
  end

  def destroy?
    user.can?('destroy:pin')
  end
end
