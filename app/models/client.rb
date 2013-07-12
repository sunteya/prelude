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
end
