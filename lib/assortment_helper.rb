# frozen_string_literal: true

module SeedHelper
  module AssortmentHelper
    class << self
      def generate
        assortment = Assortment.create!(name: "#{Faker::Address.country_code_long} #{Faker::Food.dish}".pluralize,
                                        description: Faker::SiliconValley.quote)

        rand(1..6).times do
          assortment.pins << Pin.all.sample
        end

        rand(1..2).times do |i|
          SeedHelper.image_for(assortment, i)
        end
      end
    end
  end
end
