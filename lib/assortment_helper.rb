# frozen_string_literal: true

require 'utilities/synchronized_array'

module SeedHelper
  module AssortmentHelper
    class << self
      def generate
        assortment = Assortment.create!(name: "#{Faker::Address.country_code_long} #{Faker::Food.dish}".pluralize,
                                        description: Faker::SiliconValley.quote)

        pin_ids = SynchronizedArray.new(Pin.all.to_a, Mutex.new)

        Parallel.map(rand(1..6).times, in_threads: 4) do
          assortment.pins << pin_ids.delete_sample!
        end

        rand(1..2).times do |i|
          SeedHelper.image_for(assortment, i)
        end
      end
    end
  end
end
