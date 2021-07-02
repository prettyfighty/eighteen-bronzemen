class RemoveTagFromMission < ActiveRecord::Migration[6.1]
  def change
    remove_column :missions, :tag, :string
  end
end
