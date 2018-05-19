# frozen_string_literal: true

module SeedHelper
  module CollectionHelper
    class << self
      def generate
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
    end
  end
end
