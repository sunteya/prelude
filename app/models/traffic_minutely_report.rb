class TrafficMinutelyReport
  attr_accessor :remote_ips
  
  def initialize(scope)
    # @now = #Time.now
    @scope = scope
    @step = 1.minute
    
    # @now = Time.parse("2013-02-06 13:34:26")
    @now = Time.now
    @end_at = @now.change(:sec => 0)
    @start_at = @end_at - 60.minutes #1.hour
  end
  
  def time(start_at, end_at)
    @start_at = start_at
    @end_at = end_at
  end
  
  def generate
    @remote_ips = []
    @data = {}
    
    @scope.minutely.where(:start_at.gte => @start_at.dup, :start_at.lt => @end_at.dup).each do |t|
      @data[t.start_at] ||= {}
      @remote_ips << t.remote_ip if !@remote_ips.include?(t.remote_ip)
      @data[t.start_at][t.remote_ip] = t
    end
  end
  
  def issues
    issues = []
    time = @start_at
    
    while (time < @end_at)
      issues << time
      time += @step
    end
    issues
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
  
end

# r = TrafficMinutelyReport.new(User.first.traffics); r.generate; 1