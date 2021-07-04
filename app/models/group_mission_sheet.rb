class GroupMissionSheet < ApplicationRecord
  belongs_to :group
  belongs_to :mission
end
