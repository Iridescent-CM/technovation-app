# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new(
  first_name: 'Cory',
  last_name: 'Li',
  email: 'finalepsilon@gmail.com',
  parent_email: 'finalepsilon@gmail.com',
  password: 'testtest',
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Raleigh',
  home_state: 'NC',
  home_country: 'US'
)
user.skip_confirmation!
user.save!

setting = Setting.create(
  key: 'year',
  value: '2015',
)

setting = Setting.create(
  key:'cutoff',
  value: Date.today.to_s,
)

ann = Annoucement.create(
  title: "Welcome to Technovation's new site",
  post: "For the 2015 season, we're using a brand new website to organize, submit, and publish your projects. If you have any questions, please email us at info@technovationchallenge.org!",
  published: true,
)
