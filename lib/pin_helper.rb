# frozen_string_literal: true

require 'pin'

module SeedHelper
  module PinHelper
    class << self
      def generate
        pin = Pin.create!(name: "#{Faker::Address.country_code_long} #{Faker::Food.dish}",
                          year: Faker::Time.between(18.years.ago, Time.zone.today).year,
                          description: Faker::Hacker.say_something_smart,
                          tags: PinHelper.generate_tags)
        rand(1..3).times.each do |i|
          SeedHelper.image_for(pin, i)
        end
      end

      def generate_tags
        { 'Color': [Faker::Color.color_name, nil, nil].sample,
          'Affiliate': %w[INDI DIVA MNDI CADI TURKEY CHINA MADI NYDI TNDI GADI FLDI ALDI OHDI MIDI].sample,
          'Designer': ['Elizabeth Newell', 'Elizabeth Florez', 'Nina Schwenk', 'Frank Begun', 'Bruce Newell',
                       nil, nil, nil].sample,
          'Theme': %w[cat dog dragon wolf chicken humans technology].sample }.compact
      end
    end
  end
end
