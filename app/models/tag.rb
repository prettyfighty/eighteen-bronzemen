class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :missions, through: :taggings
end
