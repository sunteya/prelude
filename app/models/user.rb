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
#  invitation_token       :string(255)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  lock_version           :integer          default(0)
#  binding_port           :integer
#  invitation_created_at  :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :traffics, dependent: :delete_all
  has_many :host_lists, dependent: :delete_all

  before_create :ensure_authentication_token
  before_create :ensure_monthly_transfer_on_create
  before_save   :ensure_binding_port

  scope :without_invitation_not_accepted, ->() { where("invitation_accepted_at IS NOT NULL OR (invitation_accepted_at IS NULL AND invitation_token IS NULL)") }
  scope :available, ->() { without_invitation_not_accepted.where { transfer_remaining > 0 } }

  def host_list(policy)
    host_lists.policy(policy).first_or_create
  end

  def ensure_monthly_transfer_on_create
    self.transfer_remaining = self.monthly_transfer if self.transfer_remaining <= 0
  end

  def ensure_authentication_token
    self.authentication_token ||= SecureRandom.hex(16)
  end

  def ensure_binding_port
    if binding_port.nil?
      begin
        port = rand(30000..50000)
      end while User.where(binding_port: port).exists?
      self.binding_port = port
    end
  end

  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end

  def transfer_using
    self.monthly_transfer - self.transfer_remaining
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
