class AddStatusToWorkLog < ActiveRecord::Migration[6.0]
  def change
    add_column :work_logs, :status, :string, default: 'Valid'
  end
end
