class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  
  has_many :binds
  has_many :traffics
  
  before_create :ensure_authentication_token
  after_create :apply_binding_and_transfer
  
  scope :available, ->() { where { transfer_remaining > 0 } }
  
  def apply_binding_and_transfer
    if self.binding.nil?
      self.binds.create
      self.transfer_remaining = self.monthly_transfer if self.transfer_remaining <= 0
      self.save!
    end
  end
  
  def binding
    binds.using.first
  end
  
  def binding_port
    binding.port if binding
  end
  
  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end
  
  def recharge
    self.transfer_remaining = self.monthly_transfer if self.monthly_transfer
    self.save
  end
  
end
