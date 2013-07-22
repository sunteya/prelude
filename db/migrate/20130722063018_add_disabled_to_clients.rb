class AddDisabledToClients < ActiveRecord::Migration
  def change
    change_table(:clients) do |t|
      t.boolean :disabled, default: false
    end
  end
end
