# frozen_string_literal: true

require 'user'
require 'authentication'

module SeedHelper
  module UserHelper
    class << self
      def generate
        user = User.create(email: Faker::Internet.unique.email,
                            display_name: Faker::Name.name,
                            bio: Faker::HitchhikersGuideToTheGalaxy.marvin_quote,
                            authentications_attributes: [{ uid: Faker::Number.number(10),
                                                           provider: %w[google facebook].sample,
                                                           token: Faker::Crypto.unique.md5,
                                                           token_expires_at: Time.now.utc + 14.days }])
        rand(0..5).times do |i|
          SeedHelper.image_for(user, i)
        end
      end

      def generate_pinster_admin
        User.find_or_create_by!(email: 'pinsterteam@gmail.com',
                                display_name: 'Andrew',
                                bio: "Pinster, it can't be beat!",
                                role: 1) do |user|
          user.authentications << Authentication.new(user: user, uid: Faker::Number.number(10),
                                                     provider: %w[google facebook].sample,
                                                     token: Faker::Crypto.unique.md5,
                                                     token_expires_at: Time.now.utc + 14.days)
        end
      end
    end
  end
end
