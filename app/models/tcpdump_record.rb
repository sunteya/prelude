class TcpdumpRecord
  include Mongoid::Document
  include Mongoid::Search

  field :access_at, type: Time
  field :link_level, type: String # in, out
  field :src, type: String
  field :sport, type: Integer
  field :dst, type: String
  field :dport, type: Integer
  field :size, type: Integer
  
  field :filename, type: String
  field :content, type: String
  
  def access_begin_minute_at
    self.access_at.change(:sec => 0, :usec => 0)
  end
  
  def local_port
    link_level == "out" ? self.sport : self.dport
  end
  
  def remote_ip
    link_level == "out" ? self.dst : self.src
  end
  
  def minute_key
    [ self.access_begin_minute_at, self.local_port, self.remote_ip ]
  end
  
  def incoming_bytes
    link_level == "out" ? 0 : self.size
  end
  
  def outgoing_bytes
    link_level == "out" ? self.size : 0
  end
  
  def total_transfer_bytes
    self.incoming_bytes + self.outgoing_bytes
  end
end
