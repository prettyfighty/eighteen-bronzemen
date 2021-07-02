class Mission < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  enum status: { pending: 0, in_progress: 1, done: 2 }
  enum priority: { high: 1, medium: 2, low: 3 }

  validates :title, presence: true
  validates :content, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :check_start_at
  validate :check_end_at

  def self.tagged_with(name)
    Tag.find_by!(name: name).missions
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |item|
      Tag.where(name: item.strip).first_or_create!
    end
  end

  private
  def check_start_at
    errors.add(:start_at, I18n.t("later_than_now")) if self.start_at? && self.start_at < Time.now - 10.minutes
  end

  def check_end_at
    errors.add(:end_at, I18n.t("later_than_start_at")) if self.end_at? && self.end_at < self.start_at
  end
end
