class Authentication < ApplicationRecord
  has_secure_token

  belongs_to :user

  validates :token, uniqueness: true

  def token_valid?
    token_expires_at > DateTime.current
  end

  def refresh_token
    self.token_expires_at = DateTime.current + 3.hours
    regenerate_token
  end
end