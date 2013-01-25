class Bind
  include Mongoid::Document
  include Mongoid::Search

  belongs_to :user
  belongs_to :port

  field :start_at, :type => Time
  field :end_at, :type => Time

  scope :using, ->() { where(end_at: nil) }
  
end
