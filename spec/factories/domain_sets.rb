# == Schema Information
#
# Table name: domain_sets
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string
#  family     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :domain_set do
    sequence(:title) {|n| "title-#{n}" }
    sequence(:content) { "#{title}.com" }
    family { :blocked }
  end
end
