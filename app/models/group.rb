class Group < ApplicationRecord
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :group_mission_sheets, dependent: :destroy
  has_many :missions, through: :group_mission_sheets

  validates :name, presence: true
  validates :privacy, presence: true

  before_create :generate_random_code

  enum privacy: { public_group: 0, private_group: 1 }

  private
  def generate_random_code
    require 'securerandom'
    new_random_code = SecureRandom.urlsafe_base64(4)
    # 判斷該random_code是否重複
    while self.class.exists?(code: new_random_code)
      new_random_code = SecureRandom.urlsafe_base64(4)
    end
    self.code = new_random_code
  end
end
