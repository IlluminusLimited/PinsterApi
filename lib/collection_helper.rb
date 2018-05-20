# frozen_string_literal: true

module SeedHelper
  module CollectionHelper
    class << self
      def generate
        collection = Collection.create!(name: %w[Favorites Wishlist].sample,
                                        description: Faker::Movie.quote,
                                        user: User.all.sample)

        rand(1..20).times.each do
          rand(0..5).times.each do
            CollectableCollection.create(collection: collection,
                                         collectable: Assortment.all.sample,
                                         count: rand(1..3))
          end
          rand(0..10).times.each do
            CollectableCollection.create(collection: collection,
                                         collectable: Pin.all.sample,
                                         count: rand(1..15))
          end
        end

        rand(0..2).times do |i|
          SeedHelper.image_for(collection, i)
        end
      end
    end
  end
end
