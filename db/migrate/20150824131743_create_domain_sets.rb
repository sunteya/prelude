class CreateDomainSets < ActiveRecord::Migration
  def change
    create_table :domain_sets do |t|
      t.text :content
      t.string :title
      t.string :family

      t.timestamps null: false
    end

    add_index :domain_sets, :family
  end
end
