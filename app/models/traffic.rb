class Traffic
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Symbolize

  belongs_to :user
  belongs_to :bind
  
  field :start_at, type: Time
  symbolize :period, :in => [:minutely, :hourly, :daily], :scopes => true
  field :remote_ip, type: String
  
  field :incoming_bytes, type: Integer
  field :outgoing_bytes, type: Integer
  field :total_transfer_bytes, type: Integer
  
  before_save :build_total_transfer_bytes
  
  def build_total_transfer_bytes
    self.total_transfer_bytes = self.incoming_bytes + self.outgoing_bytes
  end
  
end