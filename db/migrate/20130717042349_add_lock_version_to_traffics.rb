class AddLockVersionToTraffics < ActiveRecord::Migration
  def change
    change_table(:traffics) do |t|
      t.integer :lock_version, default: 0
    end

    add_index :traffics, [ :period, :user_id, :start_at, :remote_ip ]
  end
end
