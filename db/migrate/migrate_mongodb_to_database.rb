ROOT = ::File.expand_path('../../..',  __FILE__)
require ::File.join(ROOT, 'config/environment')


module MongoidModel
  class Bind
    include Mongoid::Document
    store_in collection: "binds"

    belongs_to :user
    field :port, type: Integer
    field :start_at, type: Time, default: -> { Time.now } 
    field :end_at, :type => Time
    
  end

  class Traffic
    include Mongoid::Document
    store_in collection: "traffics"

    belongs_to :user
    belongs_to :bind

    field :start_at, type: Time
    field :period, type: String
    field :remote_ip, type: String

    field :incoming_bytes, type: Integer, default: 0
    field :outgoing_bytes, type: Integer, default: 0
    field :total_transfer_bytes, type: Integer
  end

  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    store_in collection: "users"

    ## Database authenticatable
    field :email,              type: String, default: ""
    field :encrypted_password, type: String, default: ""

    ## Recoverable
    field :reset_password_token,   type: String
    field :reset_password_sent_at, type: Time

    ## Rememberable
    field :remember_created_at, type: Time

    ## Trackable
    field :sign_in_count,      type: Integer, default: 0
    field :current_sign_in_at, type: Time
    field :last_sign_in_at,    type: Time
    field :current_sign_in_ip, type: String
    field :last_sign_in_ip,    type: String
    
    ## Invitable
    field :invitation_token,       type: String
    field :invitation_sent_at,     type: Time
    field :invitation_accepted_at, type: Time
    field :invitation_limit,       type: Integer
    field :invited_by_id,          type: Integer
    field :invited_by_type,        type: String
      
    ## Token authenticatable
    field :authentication_token, type: String

    field :superadmin, type: Boolean, default: false
    field :memo, type: String
    
    field :transfer_remaining, type: Integer, default: 0
    field :monthly_transfer, type: Integer, default: 2.gigabytes
    
    has_many :binds
    has_many :traffics
    
  end
end


module DatabaseModel
  class User < ActiveRecord::Base
  end

  class Bind < ActiveRecord::Base
  end

  class Traffic < ActiveRecord::Base
  end
end



DatabaseModel::User.delete_all
DatabaseModel::Bind.delete_all
DatabaseModel::Traffic.delete_all

MongoidModel::User.all.each do |mongo_user|
  user = DatabaseModel::User.new
  attrs = mongo_user.attributes.to_h
  attrs.delete("_id")
  attrs.delete("login")

  attrs["created_at"] ||= attrs["updated_at"]

  # binding.pry
  # dfsdf

  user.attributes = attrs
  user.save!

  bind_mapping = {}
  mongo_user.binds.all.each do |mongo_bind|
    bind = DatabaseModel::Bind.new
    bind.port = mongo_bind.port
    bind.start_at = mongo_bind.start_at
    bind.end_at = mongo_bind.end_at
    bind.user_id = user.id
    bind.save!

    bind_mapping[mongo_bind.id] == bind
  end

  mongo_user.traffics.all.each do |mongo_traffic|
    traffic = DatabaseModel::Traffic.new
    traffic.start_at = mongo_traffic.start_at
    traffic.period = mongo_traffic.period
    traffic.remote_ip = mongo_traffic.remote_ip
    traffic.incoming_bytes = mongo_traffic.incoming_bytes
    traffic.outgoing_bytes = mongo_traffic.outgoing_bytes
    traffic.total_transfer_bytes = mongo_traffic.total_transfer_bytes

    traffic.user_id = user.id
    traffic.bind_id = bind_mapping[mongo_traffic.bind_id].try(:id)
    traffic.save!
  end
end


# bundle exec ruby db/migrate/migrate_mongodb_to_database.rb 