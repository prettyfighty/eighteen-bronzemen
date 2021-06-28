class AddConstraintsToColumnsOfMissions < ActiveRecord::Migration[6.1]
  def change
    change_column_null :missions, :title, false
    change_column_null :missions, :content, false
    change_column_null :missions, :start_at, false
    change_column_null :missions, :end_at, false
  end
end
