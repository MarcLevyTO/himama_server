class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :user_id, null: false

      t.string :event_type, null: false
      t.string :data
      t.string :data_type

      t.timestamps
    end
  end
end
