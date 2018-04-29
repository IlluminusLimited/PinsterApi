# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :uuid             not null, primary key
#  bio          :text
#  display_name :string
#  email        :string           not null
#  role         :integer          default("user"), not null
#  verified     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :images, as: :imageable, dependent: :destroy

  has_many :collections, dependent: :destroy
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :email, uniqueness: true

  # All users default to having a role of 3
  def user?
    role < 4
  end

  def moderator?
    role < 3
  end

  def admin?
    role < 2
  end

  def owns?(resource)
    return false unless resource.respond_to?(:user_id)
    resource.user_id == id
  end

  def to_s
    "User: '#{id}:#{email}'"
  end
end
