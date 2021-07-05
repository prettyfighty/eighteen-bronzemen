class AddFileToMissions < ActiveRecord::Migration[6.1]
  def change
    add_column :missions, :file, :string
  end
end
