class AddCascadeTransferRemainingToTraffics < ActiveRecord::Migration
  def change
    change_table(:traffics) do |t|
      t.boolean :calculate_transfer_remaining, default: false
      t.string  :upcode

      t.change  :total_transfer_bytes, :integer, limit: 8, default: 0
    end

    add_index :traffics, :upcode
  end
end
