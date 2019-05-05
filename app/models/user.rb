# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :uuid             not null, primary key
#  bio              :text
#  display_name     :string
#  images_count     :integer          default(0), not null
#  verified         :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :text             not null
#
# Indexes
#
#  index_users_on_external_user_id  (external_user_id) UNIQUE
#  index_users_on_images_count      (images_count)
#

class User < ApplicationRecord
  include Imageable

  has_many :collections, dependent: :destroy

  validates :external_user_id, presence: true, uniqueness: true
  validates :display_name, presence: true

  def self.anon_user
    new(id: nil, display_name: 'Anonymous', external_user_id: nil)
  end

  def anonymous?
    id.nil?
  end

  def user?
    external_user_id.present?
  end

  def owns?(resource)
    return false unless resource.respond_to?(:user_id)

    resource.user_id == id
  end

  def to_s
    "User:<#{id}:#{external_user_id}:'#{display_name}'>"
  end
end
