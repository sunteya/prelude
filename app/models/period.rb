module Period
  class Base
    include Comparable
    
    attr_accessor :time
    
    def initialize(time)
      self.time = time
    end
    
    def <=>(other)
      self.start_at <=> other.start_at
    end
    
    def next
      next_time = self.time + step
      self.class.new(next_time)
    end
    
    def to_end(end_period)
      result = []
      
      period = self
      while (period < end_period)
        result << period
        period = period.next
      end
      
      result
    end
  end
  
  class Minutely < Base
    def step
      1.minute
    end
    
    def start_at
      self.time.change(:sec => 0)
    end
  end
end