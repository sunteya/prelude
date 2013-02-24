module Period
  class Base
    include Comparable
    
    attr_accessor :start_at
    
    def initialize(time)
      self.start_at = adjust_to_start_at(time)
    end
    
    def eql?(other)
      self.start_at == other.start_at
    end
    
    def hash
      self.start_at.hash
    end
    
    def <=>(other)
      self.start_at <=> other.start_at
    end
    
    def succ
      next_time = self.start_at + step
      self.class.new(next_time)
    end
    
    def include?(val)
      self.start_at <= val && val < self.next.start_at
    end
  end
  
  class Minutely < Base
    def step
      1.minute
    end
    
    def adjust_to_start_at(time)
      time.change(:sec => 0)
    end
  end
  
  class Hourly < Base
    def step
      1.hour
    end
    
    def adjust_to_start_at(time)
      time.beginning_of_hour
    end
  end
end