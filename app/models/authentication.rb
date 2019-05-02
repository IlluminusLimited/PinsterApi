# frozen_string_literal: true

# == Schema Information
#
# Table name: authentications
#
#  id               :uuid             not null, primary key
#  provider         :string           not null
#  token            :string           default("")
#  token_expires_at :datetime
#  uid              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :uuid             not null
#
# Indexes
#
#  index_authentications_on_user_id  (user_id)
#

class Authentication < ApplicationRecord
  has_secure_token

  belongs_to :user

  validates :token, uniqueness: true
  validates :user, presence: true
  validates :provider, presence: true
  validates :uid, presence: true

  def token_valid?
    token_expires_at && token_expires_at > Time.now.utc
  end

  def refresh_token
    self.token_expires_at = Time.now.utc + 14.days
    # ActiveRecord can generate a secure token because we called has_secure_token
    regenerate_token
    self
  end
end
