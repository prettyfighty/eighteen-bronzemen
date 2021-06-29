class Mission < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, in_progress: 1, done: 2 }
  enum priority: { high: 1, medium: 2, low: 3 }

  validates :title, presence: true
  validates :content, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :check_start_at
  validate :check_end_at

  private
  def check_start_at
    errors.add(:start_at, I18n.t("later_than_now")) if self.start_at? && self.start_at < Time.now
  end

  def check_end_at
    errors.add(:end_at, I18n.t("later_than_start_at")) if self.end_at? && self.end_at < self.start_at
  end
end
