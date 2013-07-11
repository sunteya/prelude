class CreateTcpdumpRecords < ActiveRecord::Migration
   def up
    create_table(:tcpdump_records) do |t|
      t.datetime   :access_at
      t.string     :link_level

      t.string     :src
      t.integer    :sport

      t.string     :dst
      t.integer    :dport

      t.decimal    :size
      t.string     :filename
      t.string     :content
    end
  end

  def down
    drop_table :tcpdump_records
  end
end
