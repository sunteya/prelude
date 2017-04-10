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

class HostList < ApplicationRecord
  enumerize :policy, in: [ :black, :white, :speed ], scope: true
  belongs_to :user

  before_save :ensure_token

  def ensure_token
    self.token = SecureRandom.hex
  end

  def to_param
    token
  end
end
