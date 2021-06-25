class User < ApplicationRecord
  has_many :missions, dependent: :destroy

  


end
