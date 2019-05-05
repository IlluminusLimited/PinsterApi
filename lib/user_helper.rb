# frozen_string_literal: true

module SeedHelper
  module UserHelper
    class << self
      def generate
        User.create!(display_name: Faker::Name.name,
                     bio: Faker::HitchhikersGuideToTheGalaxy.marvin_quote,
                     external_user_id: Faker::Number.number(24))
      end

      def generate_pinster_admin
        User.find_or_create_by!(display_name: 'Andrew',
                                bio: "Pinster, it can't be beat!",
                                external_user_id: 'facebook|10215762532594846')
      end
    end
  end
end
