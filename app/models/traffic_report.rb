require 'digest/sha1'

module TrafficReport
  
  class Base
    attr_accessor :remote_ips
    attr_accessor :range
    attr_accessor :limit
    
    def initialize(scope, range, limit = nil)
      @scope = scope
      self.range = range
      self.limit = limit
    end
    
    def remote_ip_colors
      @remote_ips.map { |ip| "#" + Digest::SHA1.hexdigest(ip)[0, 6] }
    end
    
    def build_period(time)
      self.class.build_period(time)
    end
    
    def periods
      self.range.to_a
    end
    
    def generate
      @remote_ips = []
      @data = {}

      min_start_at = self.range.min.start_at.dup
      max_start_at = self.range.max.succ.start_at.dup
      @scope.where { (start_at >= min_start_at) &
                     (start_at < max_start_at) }.all.each do |t|
        period = build_period(t.start_at)
        @data[period] ||= {}
        @remote_ips << t.remote_ip if !@remote_ips.include?(t.remote_ip)
        @data[period][t.remote_ip] ||= []
        @data[period][t.remote_ip] << t
      end
      
      self
    end
    
    def chart
      self.range.map do |period|
        item = {}
        item["start_at"] = period.start_at
        item["total_transfer_bytes"] = 0
        
        if self.limit.nil? || period <= self.limit
          remote_ips_traffics = @data[period] || {}
          @remote_ips.each do |remote_ip|
            traffics = remote_ips_traffics[remote_ip] || []
            item[remote_ip] = traffics.map(&:total_transfer_bytes).sum
            item["total_transfer_bytes"] += item[remote_ip]
          end
        end
        
        item
      end
    end
    
    def total_remote_ip_chart
      total = {}
      
      @data.each_pair do |period, remote_ips_traffics|
        remote_ips_traffics.each_pair do |remote_ip, traffics|
          total[remote_ip] ||= 0
          total[remote_ip] += traffics.map(&:total_transfer_bytes).sum
        end
      end

      @remote_ips.map do |remote_ip|
        {
          label: remote_ip,
          value: (total[remote_ip] || 0)
        }
      end
    end
  end
  
  class Minutely < Base
    def self.build_period(time)
      Period::Minutely.new(time)
    end
    
    def self.recent(scope)
      now = Time.now
      end_period = build_period(now)
      start_period = build_period(now - 2.hours)
      
      self.new(scope.period('minutely'), (start_period ... end_period)).generate
    end
  end
  
  class Hourly < Base
    def self.build_period(time)
      Period::Hourly.new(time)
    end
    
    def self.today(scope)
      now = Time.now
      start_at = now.beginning_of_day
      
      limit_period = build_period(now)
      start_period = build_period(start_at)
      end_period = build_period(start_at + 1.day)
      self.new(scope.period('minutely'), (start_period ... end_period), limit_period).generate
    end
  end

  class Daily < Base

    def self.build_period(time)
      Period::Daily.new(time)
    end

    def self.this_month(scope)
      now = Time.now
      start_at = now.beginning_of_month
      
      limit_period = build_period(now)
      start_period = build_period(start_at)

      end_period = build_period(start_at.end_of_month + 1.day)
      self.new(scope.period('daily'), (start_period ... end_period), limit_period).generate
    end
  end
  
end

