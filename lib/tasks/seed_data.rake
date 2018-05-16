# frozen_string_literal: true

task seed_data: :environment do
  require 'faker'
  require 'seed_helper'
  include SeedHelper

  50.times.each do
    User.create!(email: Faker::Internet.unique.email,
                 display_name: Faker::Name.name,
                 bio: Faker::HitchhikersGuideToTheGalaxy.marvin_quote)
  end

  User.find_or_create_by!(email: Faker::Internet.unique.email,
                          display_name: 'Andrew',
                          bio: "Pinster, it can't be beat!",
                          role: 1)

  User.all.each do |user|
    SeedHelper.generate_authentication(user)
  end

  500.times.each do
    SeedHelper.generate_pin
  end

  30.times.each do
    SeedHelper.generate_assortment
  end

  100.times.each do
    SeedHelper.generate_collection
  end
end
