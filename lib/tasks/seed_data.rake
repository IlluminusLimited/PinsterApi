# frozen_string_literal: true

task seed_data: :environment do
  require 'faker'
  require 'seed_helper'
  include SeedHelper

  logger = Logger.new(STDOUT)

  logger.info{"Deleting everything"}

  User.destroy_all
  Pin.destroy_all
  Assortment.destroy_all
  Collection.destroy_all

  logger.info{"Creating users!"}
  100.times.each do
    User.create!(email: Faker::Internet.unique.email,
                 display_name: Faker::Name.name,
                 bio: Faker::HitchhikersGuideToTheGalaxy.marvin_quote)
  end

  User.find_or_create_by!(email: Faker::Internet.unique.email,
                          display_name: 'Andrew',
                          bio: "Pinster, it can't be beat!",
                          role: 1)
  logger.info{"Generating authentications!"}

  User.all.each do |user|
    SeedHelper.generate_authentication(user)
  end

  logger.info{"Creating pins!"}

  50.times.each do
    SeedHelper.generate_pin
  end

  logger.info{"Creating assortments!"}

  10.times.each do
    SeedHelper.generate_assortment
  end

  logger.info{"Creating collections!"}

  20.times.each do
    SeedHelper.generate_collection
  end
end
