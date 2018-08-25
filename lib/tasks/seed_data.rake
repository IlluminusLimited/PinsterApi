# frozen_string_literal: true

task seed_data: :environment do
  require 'seed_helper'
  include SeedHelper

  logger = Logger.new(STDOUT)

  SeedHelper.purge_database(logger)

  logger.info { "Creating users!" }

  SeedHelper::UserHelper.generate_pinster_admin

  Parallel.map(50.times, in_threads: 4) do
    SeedHelper::UserHelper.generate
  end

  logger.info { "Creating pins!" }

  Parallel.map(200.times, in_threads: 4) do
    SeedHelper::PinHelper.generate
  end

  logger.info { "Creating assortments!" }

  Parallel.map(50.times, in_processes: Concurrent.processor_count) do
    SeedHelper::AssortmentHelper.generate
  end

  logger.info { "Creating collections!" }

  Parallel.map(200.times, in_processes: Concurrent.processor_count) do
    SeedHelper::CollectionHelper.generate
  end

  logger.info { "Done!" }
end
