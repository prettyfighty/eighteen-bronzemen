class ChangePrivacyType < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :privacy, :string
    add_column :groups, :privacy, :integer
  end
end
