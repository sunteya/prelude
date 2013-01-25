class Rent
  include Mongoid::Document
  include Mongoid::Search

  belongs_to :user
  belongs_to :port

  field :user_id, :type => Integer
  field :port_id, :type => Integer
  field :start_at, :type => Time
  field :end_at, :type => Time
  # field :over, :type => Boolean, :default => false

end
