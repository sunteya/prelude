class UseLongReplaceDecimal < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.change :transfer_remaining, :integer, limit: 8, default: 0
      t.change :monthly_transfer, :integer, limit: 8, default: 2.gigabytes
    end

    change_table(:traffics) do |t|
      t.change :incoming_bytes, :integer, limit: 8, default: 0
      t.change :outgoing_bytes, :integer, limit: 8, default: 0
      t.change :total_transfer_bytes, :integer, limit: 8
    end

    change_table(:tcpdump_records) do |t|
      t.change :size, :integer, limit: 8
    end
  end
end
