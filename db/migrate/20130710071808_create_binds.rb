class CreateBinds < ActiveRecord::Migration
  def up
    create_table(:binds) do |t|
      t.references :user
      t.integer    :port
      t.datetime   :start_at
      t.datetime   :end_at
    end

    add_index :binds, :user_id
  end

  def down
    drop_table :binds
  end
end
