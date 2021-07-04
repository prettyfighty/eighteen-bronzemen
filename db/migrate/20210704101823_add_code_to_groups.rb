class AddCodeToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :code, :string
  end
end
