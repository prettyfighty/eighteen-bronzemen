class Mission < ApplicationRecord
  # belongs_to :user

  enum priority: { high: 1, medium: 2, low: 3 }
  # enum priorities: { "高": 1, "中": 2, "低": 3 }

end
