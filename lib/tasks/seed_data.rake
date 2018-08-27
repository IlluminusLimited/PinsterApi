# frozen_string_literal: true

task seed_data: :environment do
  require 'seed_helper'
  include SeedHelper

  logger = Logger.new(STDOUT)
  max_processes = Concurrent.processor_count

  # SeedHelper.purge_database(logger)

  logger.info { "Creating users!" }

  SeedHelper::UserHelper.generate_pinster_admin

  Parallel.map(500.times, in_processes: max_processes) do
    SeedHelper::UserHelper.generate
  end

  logger.info { "Creating pins!" }

  Parallel.map(2000.times, in_processes: max_processes) do
    SeedHelper::PinHelper.generate
  end

  logger.info { "Creating assortments!" }

  Parallel.map(500.times, in_processes: max_processes) do
    SeedHelper::AssortmentHelper.generate
  end

  logger.info { "Creating collections!" }
  asses = Assortment.all.pluck(:id)
  pins = Pin.all.pluck(:id)
  Parallel.map(2000.times, in_processes: max_processes) do
    SeedHelper::CollectionHelper.generate(asses, pins)
  end

  logger.info { "Done!" }
end
