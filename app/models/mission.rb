class Mission < ApplicationRecord
  # belongs_to :user

  enum priorities: { "高": 1, "中": 2, "低": 3 }

end
