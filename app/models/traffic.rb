class Traffic < ActiveRecord::Base
  belongs_to :user
  belongs_to :bind
  
  symbolize :period, in: [:minutely, :hourly, :daily], scopes: :shallow

  before_save :build_total_transfer_bytes
  
  def build_total_transfer_bytes
    self.total_transfer_bytes = self.incoming_bytes + self.outgoing_bytes
  end
  
  def self.sum_transfer_bytes(groups = [])
    select_columns = [
      "SUM(total_transfer_bytes) AS total_transfer_bytes",
      "SUM(incoming_bytes) AS incoming_bytes",
      "SUM(outgoing_bytes) AS outgoing_bytes"
    ]
    select_columns += groups

    group(groups).select(select_columns.join(", "))
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
    
    Traffic.minutely.where { |q| (q.start_at >= start_at.dup) & (q.start_at < end_at.dup) }
      .sum_transfer_bytes([ :user_id, :remote_ip ]).each do |grouped_traffic|
      tr = scope.new(grouped_traffic.attributes)
      tr.save!
    end
  end
end