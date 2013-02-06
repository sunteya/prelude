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
  
  def self.sum_transfer_bytes(groups = [])
    mappings = groups.map { |column| "          #{column}: this.#{column}" }.join(",\n")
    
    map = %Q{
      function() {
        emit({ 
          #{mappings}
        }, {
          incoming_bytes: this.incoming_bytes,
          outgoing_bytes: this.outgoing_bytes
        })
      }
    }

    reduce = %Q{
      function(key,values) {
        var result = { 
          total_transfer_bytes: 0,
          incoming_bytes: 0,
          outgoing_bytes: 0
        }
        values.forEach(function(value) {
          result.incoming_bytes += value.incoming_bytes;
          result.outgoing_bytes += value.outgoing_bytes;
        });
        result.total_transfer_bytes = result.incoming_bytes + result.outgoing_bytes;
        return result;
      }
    }
    
    self.map_reduce(map, reduce).out(inline: 1).map { |r| r["_id"].merge(r["value"]) }
  end
  
  def fff()
    now = Time.now
    end_at = now.change(:sec => 0) # - 1.minute
    start_at = end_at - 1.hour
    
    step = 1.minute
    issues = []
    while (start_at <= end_at)
      issues << start_at
      start_at += step
    end
    
    
  end
end