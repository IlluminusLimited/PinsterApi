# frozen_string_literal: true

module SeedHelper
  module UserHelper
    class << self
      def generate
        User.create!(email: Faker::Internet.unique.email,
                     display_name: Faker::Name.name,
                     bio: Faker::HitchhikersGuideToTheGalaxy.marvin_quote,
                     authentication_attributes: { uid: Faker::Number.number(10),
                                                  provider: %w[google facebook].sample,
                                                  token: Faker::Crypto.unique.md5,
                                                  token_expires_at: Time.now.utc + 14.days })
      end

      def generate_pinster_admin
        User.find_or_create_by!(email: Faker::Internet.unique.email,
                                display_name: 'Andrew',
                                bio: "Pinster, it can't be beat!",
                                role: 1,
                                authentication_attributes: { uid: Faker::Number.number(10),
                                                             provider: %w[google facebook].sample,
                                                             token: Faker::Crypto.unique.md5,
                                                             token_expires_at: Time.now.utc + 14.days })
      end
    end
  end
end
