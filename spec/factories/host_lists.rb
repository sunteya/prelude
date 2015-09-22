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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host_list do
    user
    policy { :black }
  end
end
