class CreateTraffics < ActiveRecord::Migration
  def up
    create_table(:traffics) do |t|
      t.references :user
      t.references :bind

      t.datetime   :start_at
      t.string     :period
      t.string     :remote_ip
      t.decimal    :incoming_bytes, default: 0
      t.decimal    :outgoing_bytes, default: 0
      t.decimal    :total_transfer_bytes
    end

    add_index :traffics, :user_id
    add_index :traffics, :bind_id
  end

  def down
    drop_table :traffics
  end
end
