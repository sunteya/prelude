# == Schema Information
#
# Table name: tcpdump_records
#
#  id         :integer          not null, primary key
#  access_at  :datetime
#  link_level :string(255)
#  src        :string(255)
#  sport      :integer
#  dst        :string(255)
#  dport      :integer
#  size       :integer
#  filename   :string(255)
#  content    :string(255)
#

class TcpdumpRecord < ActiveRecord::Base

  scope :ipaddr_is, ->(ipaddr) { where { (src == ipaddr) | (dst == ipaddr) } }
  scope :port_is, ->(port) { where { (sport == port) | (dport == port) } }
  scope :recent, ->() { order("access_at DESC") }
  
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
