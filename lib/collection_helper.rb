# frozen_string_literal: true

module SeedHelper
  module CollectionHelper
    class << self
      def generate
        collection = generate_collection

        assortment_ids = Utilities::SynchronizedArray.new(Assortment.all.pluck(:id), Mutex.new)
        pin_ids = Utilities::SynchronizedArray.new(Pin.all.pluck(:id), Mutex.new)

        Parallel.map(rand(1..20).times, in_threads: 4) do
          CollectionHelper.generate_collectables(collection, assortment_ids, pin_ids)
        end

        rand(0..2).times do |i|
          SeedHelper.image_for(collection, i)
        end
      end

      def generate_collection
        Collection.create!(name: %w[Favorites Wishlist].sample,
                           description: Faker::Movie.quote,
                           user: User.all.sample)
      end

      def generate_collectables(collection, assortment_ids, pin_ids)
        rand(0..5).times.each do
          generate_assortment_collectables(collection, assortment_ids)
        end

        rand(0..10).times.each do
          generate_pin_collectables(collection, pin_ids)
        end
      end

      def generate_assortment_collectables(collection, assortment_ids)
        CollectableCollection.create(collection: collection,
                                     collectable_type: 'Assortment',
                                     collectable_id: assortment_ids.delete_sample!,
                                     count: rand(1..3))
      end

      def generate_pin_collectables(collection, pin_ids)
        CollectableCollection.create(collection: collection,
                                     collectable_type: 'Pin',
                                     collectable_id: pin_ids.delete_sample!,
                                     count: rand(1..15))
      end
    end
  end
end
