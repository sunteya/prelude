require 'digest/sha1'

module TrafficReport
  
  class Base
    attr_accessor :remote_ips
    
    def remote_ip_colors
      @remote_ips.map { |ip| "#" + Digest::SHA1.hexdigest(ip)[0, 6] }
    end
  end
  
  class Minutely < Base
    
    
    def initialize(scope, start_period, end_period)
      @scope = scope
      @start_period = start_period
      @end_period = end_period
    end
    
    def periods
      @start_period.to_end(@end_period)
    end
    
    def issues
      self.periods.map(&:start_at)
    end
    
    def generate
      @remote_ips = []
      @data = {}
      
      @scope.minutely.where(:start_at.gte => @start_period.start_at.dup,
                            :start_at.lt => @end_period.next.start_at.dup).each do |t|
        @data[t.start_at] ||= {}
        @remote_ips << t.remote_ip if !@remote_ips.include?(t.remote_ip)
        @data[t.start_at][t.remote_ip] = t
      end
      
      self
    end
    
      
    def result
      result = []
      
      issues.each do |issue|
        item = {}
        item["start_at"] = issue #I18n.l(issue, format: :hhmm)
        traffics = @data[issue] || {}
        
        @remote_ips.each do |remote_ip|
          tr = traffics[remote_ip]
          
          item[remote_ip] = 0
          item[remote_ip] = tr.total_transfer_bytes if tr
        end
        
        result << item
      end
      
      result
    end
    
    def total_chart
      total = {}
      @data.each_pair do |issue, traffics|
        traffics.each_pair do |remote_ip, traffic|
          total[remote_ip] ||= 0
          total[remote_ip] += traffic.total_transfer_bytes
        end
      end
      
      result = []
      @remote_ips.each do |remote_ip|
        result << {
          label: remote_ip,
          value: total[remote_ip] || 0
        }
      end
      result
    end
    
  end

end

