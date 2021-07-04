class Group < ApplicationRecord
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :group_mission_sheets, dependent: :destroy
  has_many :missions, through: :group_mission_sheets

  validates :name, presence: true
  validates :privacy, presence: true

  enum privacy: { public_group: 0, private_group: 1 }
end
