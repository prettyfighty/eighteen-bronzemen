class Mission < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :sharings, dependent: :destroy
  has_many :shared_users, through: :sharings, source: :user

  enum status: { pending: 0, in_progress: 1, done: 2 }
  enum priority: { high: 1, medium: 2, low: 3 }

  validates :title, presence: true
  validates :content, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
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

  # 用select2 改以陣列顯示
  def tag_items
    tags.map(&:name)
  end

  def tag_items=(names)
    self.tags = names.map do |item|
      Tag.where(name: item.strip).first_or_create! unless item.blank?
    end.compact!
  end

  def tag_items_view
    tags.map do |tag|
      %Q(<span class="tag">#{tag.name}</span>)
    end.join(' ')
  end

  private
  def check_end_at
    errors.add(:end_at, I18n.t("later_than_start_at")) if self.end_at? && self.end_at < self.start_at
  end
end
