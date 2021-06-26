class ChangeStatusType < ActiveRecord::Migration[6.1]
  def change
    remove_column :missions, :status, :string
    add_column :missions, :status, :integer
  end
end
