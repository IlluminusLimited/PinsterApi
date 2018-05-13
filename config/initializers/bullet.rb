# frozen_string_literal: true

unless Rails.env.production?
  require 'bullet'
  Bullet.enable = true
  Bullet.rails_logger = true
  # Bullet.raise = true
end
