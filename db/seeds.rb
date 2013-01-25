# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.all.destroy

User.create(
  :email => "msyesyan@gmail.com",
  :login => "msyesyan",
  :password => "11111111",
  :password_confirmation => "11111111",
  :admin =>  true,
  :domain => "msyesyan.wido.me"
)