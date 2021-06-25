class Mission < ApplicationRecord
  # belongs_to :user

  # enum priorities: { "1": "高", "2": "中", "3": "低" }
  enum priorities: { "高": 1, "中": 2, "低": 3 }

end
