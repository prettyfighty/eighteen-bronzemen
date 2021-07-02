class Tag < ApplicationRecord
  has_many :taggings
  has_many :missions, through: :taggings
end
