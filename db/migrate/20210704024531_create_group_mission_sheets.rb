class CreateGroupMissionSheets < ActiveRecord::Migration[6.1]
  def change
    create_table :group_mission_sheets do |t|
      t.belongs_to :group, null: false, foreign_key: true
      t.belongs_to :mission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
