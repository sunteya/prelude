# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where(email: "msyesyan@gmail.com").create! do |u|
  u.login = "msyesyan"
  u.password = u.password_confirmation = "11111111"
end

User.where(email: "sunteya@gmail.com").create! do |u|
  u.login = "sunteya"
  u.password = u.password_confirmation = "12345678"
  u.superadmin = true
end