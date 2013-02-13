class Traffic
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Symbolize

  belongs_to :user
  belongs_to :bind
  
  field :start_at, type: Time
  symbolize :period, :in => [:minutely, :hourly, :daily], :scopes => true
  field :remote_ip, type: String
  
  field :incoming_bytes, type: Integer, default: 0
  field :outgoing_bytes, type: Integer, default: 0
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
  
  def self.generate_hourly_records!(time_at)
    start_at = time_at.beginning_of_hour
    self.generate_period_records!(:hourly, start_at, start_at + 1.hour)
  end
  
  def self.generate_daily_records!(time_at)
    start_at = time_at.beginning_of_day
    self.generate_period_records!(:daily, start_at, start_at + 1.day)
  end
  
  def self.generate_period_records!(period, start_at, end_at)
    scope = Traffic.where(period: period.to_s).where(start_at: start_at)
    scope.destroy_all
    Traffic.minutely.where(:start_at.gte => start_at.dup, :start_at.lt => end_at.dup)
      .sum_transfer_bytes([ :user_id, :remote_ip ]).each do |attrs|
      tr = scope.new(attrs)
      tr.save!
    end
  end
end