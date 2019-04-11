# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :uuid             not null, primary key
#  bio          :text
#  display_name :string
#  email        :string           not null
#  images_count :integer          default(0), not null
#  role         :integer          default(3), not null
#  verified     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email         (email) UNIQUE
#  index_users_on_images_count  (images_count)
#

class User < ApplicationRecord
  include Imageable

  authenticates_with_sorcery!

  has_many :collections, dependent: :destroy
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :email, presence: true, uniqueness: true
  validates :display_name, presence: true

  def self.anon_user
    new(id: nil, display_name: 'Anonymous', role: 4)
  end

  def anonymous?
    role == 4
  end

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
    "User: '#{id}:#{display_name}'"
  end
end
