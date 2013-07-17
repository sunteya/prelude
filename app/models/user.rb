# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  superadmin             :boolean          default(FALSE)
#  memo                   :string(255)
#  transfer_remaining     :integer          default(0)
#  monthly_transfer       :integer          default(2147483648)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  lock_version           :integer          default(0)
#

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
  rescue ActiveRecord::StaleObjectError
    self.reload
    retry
  end

  def consume(bytes)
    self.transfer_remaining -= bytes
    self.save
  rescue ActiveRecord::StaleObjectError
    self.reload
    retry
  end
  
end
