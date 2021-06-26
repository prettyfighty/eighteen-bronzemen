class ChangeContentType < ActiveRecord::Migration[6.1]
  def change
    remove_column :missions, :content, :string
    add_column :missions, :content, :text
  end
end
