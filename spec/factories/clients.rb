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
#  disabled       :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    sequence(:hostname) {|n| "host-#{n}" }
  end
end
