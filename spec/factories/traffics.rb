# == Schema Information
#
# Table name: traffics
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  bind_id                      :integer
#  start_at                     :datetime
#  period                       :string(255)
#  remote_ip                    :string(255)
#  incoming_bytes               :integer          default(0)
#  outgoing_bytes               :integer          default(0)
#  total_transfer_bytes         :integer          default(0)
#  calculate_transfer_remaining :boolean          default(FALSE)
#  upcode                       :string(255)
#  lock_version                 :integer          default(0)
#  client_id                    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :traffic do
    start_at { Time.current }
    remote_ip { "192.168.1.#{rand(256)}" }
    incoming_bytes { rand(100000) }
    outgoing_bytes { rand(100000) }

    trait :immediate do
      period :immediate
      sequence(:upcode) {|n| "upcode-#{n}"}
    end
  end
end
