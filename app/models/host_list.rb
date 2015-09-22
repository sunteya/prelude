# == Schema Information
#
# Table name: host_lists
#
#  id         :integer          not null, primary key
#  token      :string
#  user_id    :integer
#  policy     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HostList < ActiveRecord::Base
  belongs_to :user
  symbolize :policy, in: [ :black, :white, :speed ], scopes: true

  before_save :ensure_token

  def ensure_token
    self.token = SecureRandom.hex
  end

  def to_param
    token
  end
end
