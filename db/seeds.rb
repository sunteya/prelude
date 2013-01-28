# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.all.destroy
Port.all.destroy
Bind.all.destroy
Statistic.all.destroy

User.create!(
  email: "msyesyan@gmail.com",
  login: "msyesyan",
  password: "11111111",
  password_confirmation: "11111111",
  admin: true,
  allowed_statistics: 50000
)

# User.create!(
#   email: "sunteya@gmail.com",
#   login: "sunteya",
#   password: "12345678",
#   password_confirmation: "12345678",
#   admin: true,
#   allowed_statistics: 50000
# )

Statistic.create!(
  time: Time.now,
  size: 800  
)

Statistic.create!(
  Time: Time.now - 1.hour,
  size: 1200
)

Port.create!(
  number: 3000,
  binded: true
)

Port.create!(
  number: 3001,
  binded: false
)

user = User.all.first
port = Port.all.first
statistic = Statistic.first
statistic_2 = Statistic.last
bind = Bind.create!(
  start_at: Time.now
)

bind.user = user
bind.port = port
bind.save!

statistic.user = user
statistic.save!

statistic_2.user = user
statistic_2.save!
