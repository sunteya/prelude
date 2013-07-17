class DropTcpdumpRecords < ActiveRecord::Migration
  def change
    drop_table :tcpdump_records
  end
end
