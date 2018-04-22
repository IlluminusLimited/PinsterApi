class Collection < ApplicationRecord
  belongs_to :collectable, polymorphic: true
end
