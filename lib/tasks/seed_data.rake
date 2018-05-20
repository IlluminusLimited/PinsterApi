# frozen_string_literal: true

task seed_data: :environment do
  require 'seed_helper'
  include SeedHelper

  logger = Logger.new(STDOUT)

  SeedHelper.purge_database(logger)

  logger.info { "Creating users!" }

  SeedHelper::UserHelper.generate_pinster_admin

  50.times.each do
    SeedHelper::UserHelper.generate
  end

  logger.info { "Creating pins!" }

  200.times.each do
    SeedHelper::PinHelper.generate
  end

  logger.info { "Creating assortments!" }

  50.times.each do
    SeedHelper::AssortmentHelper.generate
  end

  logger.info { "Creating collections!" }

  200.times.each do
    SeedHelper::CollectionHelper.generate
  end
end
