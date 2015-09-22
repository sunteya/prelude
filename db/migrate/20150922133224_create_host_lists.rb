class CreateHostLists < ActiveRecord::Migration
  def change
    create_table :host_lists do |t|
      t.string :token
      t.belongs_to :user, index: true
      t.string :policy

      t.timestamps null: false
    end

    add_index :host_lists, :token
    add_index :host_lists, :policy
  end
end
