# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_or_create_by!(email: 'pinsterteam@gmail.com', display_name: 'PinsterTeam', role: 1)
Authentication.find_or_create_by!(user: user) do |auth|
  auth.provider = 'pinster'
  auth.token = SecureRandom.hex
  auth.token_expires_at = Time.zone.now + 7.days
  auth.uid = SecureRandom.hex
end