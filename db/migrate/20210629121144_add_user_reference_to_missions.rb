class AddUserReferenceToMissions < ActiveRecord::Migration[6.1]
  def change
    add_reference :missions, :user, foreign_key: true
  end
end
