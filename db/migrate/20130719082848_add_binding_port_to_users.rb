class AddBindingPortToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.integer :binding_port
    end

    Bind.where(end_at: nil).each do |bind|
      user = User.where(id: bind.user_id).first
      next if user.nil?

      begin
        user.binding_port = bind.port
        user.save
      rescue ActiveRecord::StaleObjectError
        user.reload
        retry
      end
    end
  end

  class Bind < ActiveRecord::Base
  end
end
