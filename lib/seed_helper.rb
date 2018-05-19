# frozen_string_literal: true

require 'faker'

module SeedHelper
  class << self
    def purge_database(logger)
      logger.info { "Deleting everything" }
      logger.info { "Deleting users" }

      User.destroy_all
      logger.info { "Deleting pins" }

      Pin.destroy_all
      logger.info { "Deleting assortments" }

      Assortment.destroy_all
      logger.info { "Deleting collections" }

      Collection.destroy_all
    end

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
  end
end
