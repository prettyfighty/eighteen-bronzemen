class RemoveUserIdFromMissions < ActiveRecord::Migration[6.1]
  def change
    remove_column :missions, :user_id
  end
end
