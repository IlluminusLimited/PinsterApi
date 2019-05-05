# frozen_string_literal: true

class CurrentUser < SimpleDelegator
  attr_accessor :permissions

  def with_permissions(permissions_array)
    @permissions = permissions_array
    self
  end

  def can?(action)
    return false if permissions.blank?

    @permissions.include?(action)
  end
end
