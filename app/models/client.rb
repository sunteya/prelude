# == Schema Information
#
# Table name: clients
#
#  id             :integer          not null, primary key
#  access_token   :string(255)
#  hostname       :string(255)
#  last_access_at :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class Client < ActiveRecord::Base

  before_validation :ensure_access_token

  validates :hostname, presence: true
  validates :access_token, presence: true, uniqueness: true

  def ensure_access_token
    self.access_token = SecureRandom.hex(16) if access_token.blank?
  end

end
