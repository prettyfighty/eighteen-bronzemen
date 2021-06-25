class ChangePriorityType < ActiveRecord::Migration[6.1]
  def change
    remove_column :missions, :priority, :integer
    add_column :missions, :priority, :string
  end
end
