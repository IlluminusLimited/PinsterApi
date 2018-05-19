# frozen_string_literal: true

require 'faker'

module SeedHelper
  IMAGES ||= Dir.glob(File.join('public', '*.jpg')).map { |file| file.gsub('public/', '') }.flatten.compact
  class << self
    def image_for(resource, iterator = 1)
      file = Faker::Placeholdit.image("300x300", 'jpeg', :random)
      file_name = file.match(/\d+x\d+/)[0]
      Image.create!(imageable: resource,
                    base_file_name: file_name,
                    storage_location_uri: file,
                    featured: (
                    if iterator == 1
                      [Faker::Time.between(20.days.ago, Time.zone.today), nil, nil, nil]
                          .sample
                    end))
    end

    def generate_collection
      collection = Collection.create!(name: %w[Favorites Wishlist].sample,
                                      description: Faker::Movie.quote,
                                      user: User.all.sample)

      rand(1..50).times.each do
        CollectableCollection.create!(collection: collection,
                                      collectable: [Pin.all.sample, Assortment.all.sample].sample)
      end

      rand(1..2).times do |i|
        SeedHelper.image_for(collection, i)
      end
    end

    def generate_assortment
      assortment = Assortment.create!(name: "#{Faker::Address.country_code_long} #{Faker::Food.dish}".pluralize,
                                      description: Faker::SiliconValley.quote)

      rand(1..3).times do
        assortment.pins << Pin.all.sample
      end

      rand(1..2).times do |i|
        SeedHelper.image_for(assortment, i)
      end
    end

    def generate_pin
      pin = Pin.create!(name: "#{Faker::Address.country_code_long} #{Faker::Food.dish}",
                        year: Faker::Time.between(18.years.ago, Time.zone.today).year,
                        description: Faker::Hacker.say_something_smart,
                        tags: SeedHelper.generate_tags)
      rand(1..3).times.each do |i|
        SeedHelper.image_for(pin, i)
      end
    end

    def generate_authentication(user)
      Authentication.create!(user: user,
                             uid: Faker::Number.number(10),
                             provider: %w[google facebook].sample,
                             token: Faker::Crypto.unique.md5,
                             token_expires_at: Time.now.utc + 3.hours)
    end

    def generate_tags
      { 'Color': [Faker::Color.color_name, nil, nil].sample,
        'Affilliate': %w[INDI DIVA MNDI CADI TURKEY CHINA MADI NYDI TNDI GADI FLDI ALDI OHDI MIDI].sample,
        'Designer': ['Elizabeth Newell', 'Elizabeth Florez', 'Nina Schwenk', 'Frank Begun', 'Bruce Newell', nil, nil, nil].sample,
        'Theme': %w[cat dog dragon wolf chicken humans technology].sample }.compact
    end
  end
end
