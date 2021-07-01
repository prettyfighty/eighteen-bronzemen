class ChangeForeignKeyOnDelete < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key "missions", "users"
    add_foreign_key "missions", "users", on_delete: :cascade
  end
end
