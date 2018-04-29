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
    user&.moderator?
  end

  def update?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end
end
