class AddClientIdToTraffic < ActiveRecord::Migration
  def change
    change_table(:traffics) do |t|
      t.references :client, index: true
    end
  end
end
