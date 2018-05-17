# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  tags        :jsonb            not null
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Pin < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy
  has_one :assortment, through: :pin_assortment

  scope :with_images, -> { includes(:images) }

  validates :name, presence: true

  def all_images
    Image.find_by_sql <<~SQL
      select images.*
      from images
        inner join pins on imageable_id = pins.id
      where imageable_id = '#{id}' and imageable_type = 'Pin'
      union
      select images.*
      from images
        inner join assortments on imageable_id = assortments.id and imageable_type = 'Assortment'
        inner join pin_assortments on pin_assortments.assortment_id = assortments.id
      where pin_id ='#{id}';
    SQL
  end

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: %i[
      sorted_by
      search_query
    ]
  )
  scope :search_query, lambda { |query|
                         return nil if query.blank?
                         # condition query, parse into individual keywords
                         terms = query.to_s.downcase.split(/,\s+/)
                         # replace "*" with "%" for wildcard searches,
                         # append '%', remove duplicate '%'s
                         terms = terms.map do |e|
                           (e.tr('*', '%') + '%').gsub(/%+/, '%')
                         end
                         # configure number of OR conditions for provision
                         # of interpolation arguments. Adjust this if you
                         # change the number of OR conditions.
                         num_or_conditions = 1
                         where(
                           terms.map do
                             or_clauses = [
                               "pins.name ILIKE ?"
                             ].join(' OR ')
                             "(#{or_clauses})"
                           end.join(' AND '),
                           *terms.map { |e| [e] * num_or_conditions }.flatten
                         )
                       }

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option.match?(/desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name/
      order("LOWER(pins.name) #{direction}")
    when /^created_at/
      order("pins.created_at #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }
end
