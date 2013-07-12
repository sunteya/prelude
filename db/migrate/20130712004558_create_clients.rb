class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :access_token
      t.string :hostname
      t.datetime :last_access_at

      t.timestamps
    end
  end
end
