class CreateMissions < ActiveRecord::Migration[6.1]
  def change
    create_table :missions do |t|
      t.string :title
      t.string :content
      t.string :tag
      t.string :status
      t.integer :priority
      t.datetime :start_at
      t.datetime :end_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
