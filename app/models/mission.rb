class Mission < ApplicationRecord
  # belongs_to :user
  enum status: { pending: 0, in_progress: 1, done: 2 }
  enum priority: { high: 1, medium: 2, low: 3 }
  # enum priorities: { "高": 1, "中": 2, "低": 3 }

end
