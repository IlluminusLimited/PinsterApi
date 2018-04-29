# frozen_string_literal: true

class PinPolicy
  attr_reader :user, :pin

  def initialize(user, pin)
    @user = user
    @pin = pin
  end

  def create?
    user&.user?
  end

  def new?
    user&.user?
  end

  def update?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end
end
