class Bind < ActiveRecord::Base
  belongs_to :user
  
  validates :port, uniqueness: { scope: :end_at }, allow_nil: true, if: :using?
  
  scope :using, -> { where(end_at: nil) }
  scope :pending, -> { where(port: nil) }
  
  def after_initialize
    self.start_at ||= Time.now if new_record?
  end


  def close
    self.end_at = Time.now if self.end_at.nil?
    save
  end
  
  def using?
    self.end_at.nil?
  end
  
  def self.assign_ports
    used_ports = Bind.using.map(&:port).compact.uniq
    Bind.pending.each do |bind|
      begin
        port = rand(30000..50000)
      end while used_ports.include?(port)
      
      used_ports << port
      bind.port = port
      bind.save
    end
  end
  
end
