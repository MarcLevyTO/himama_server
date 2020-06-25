class CreateWorkLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :work_logs do |t|
      t.integer :user_id, null: false

      t.integer :time_worked, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.integer :start_event_id, null: false
      t.integer :end_event_id, null: false

      t.timestamps
    end
  end
end
