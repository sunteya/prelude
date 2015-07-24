# == Schema Information
#
# Table name: traffics
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  bind_id                      :integer
#  start_at                     :datetime
#  period                       :string(255)
#  remote_ip                    :string(255)
#  incoming_bytes               :integer          default(0)
#  outgoing_bytes               :integer          default(0)
#  total_transfer_bytes         :integer          default(0)
#  calculate_transfer_remaining :boolean          default(FALSE)
#  upcode                       :string(255)
#  lock_version                 :integer          default(0)
#  client_id                    :integer
#

class Traffic < ActiveRecord::Base
  belongs_to :user
  belongs_to :bind
  
  symbolize :period, in: [:minutely, :hourly, :daily, :immediate], scopes: true
  validates :upcode, uniqueness: { scope: :client_id }, allow_blank: true

  before_save :build_total_transfer_bytes
  after_save :cascade_calculate_transfer, if: :require_calculate_transfer?
  
  def build_total_transfer_bytes
    self.total_transfer_bytes = self.incoming_bytes + self.outgoing_bytes
  end

  def require_calculate_transfer?
    self.period == :immediate
  end

  def cascade_calculate_transfer
    if self.incoming_bytes_changed? || self.outgoing_bytes_changed?
      transfer_bytes = self.total_transfer_bytes - self.total_transfer_bytes_was
      self.user.consume(transfer_bytes) if transfer_bytes != 0
      self.cascade_calculate_traffic_report
    end
  end

  def cascade_calculate_traffic_report
    access_at = self.start_at.change(:sec => 0, :usec => 0)
    traffic = Traffic.where(period: 'minutely', user_id: self.user_id, 
                            start_at: access_at, remote_ip: self.remote_ip).first_or_create

    traffic.incoming_bytes += self.incoming_bytes - self.incoming_bytes_was
    traffic.outgoing_bytes += self.outgoing_bytes - self.outgoing_bytes_was
    traffic.save!
  rescue ActiveRecord::StaleObjectError
    retry
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
    
    Traffic.period('minutely').where { |q| (q.start_at >= start_at.dup) & (q.start_at < end_at.dup) }
      .sum_transfer_bytes([ :user_id, :remote_ip ]).each do |grouped_traffic|
      tr = scope.new(grouped_traffic.attributes)
      tr.save!
    end
  end
end
