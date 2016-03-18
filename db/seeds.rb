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
  parent_email: 'cssndrx@gmail.com',
  password: 'testtest',
  role: 0,
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Raleigh',
  home_state: 'NC',
  home_country: 'US',
  school: 'MIT',
)
user.skip_confirmation!
user.save!


user = User.new(
  first_name: 'Cass',
  last_name: '??',
  email: 'cssndrx@gmail.com',
  parent_email: 'cssndrx@gmail.com',
  password: 'testtest',
  role: 0,
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Raleigh',
  home_state: 'VA',
  home_country: 'US',
  school: 'MIT',
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Cassandra',
  last_name: 'Xia',
  email: 'cssndrx+judge@gmail.com',
  password: 'testtest',
  role: 3,
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Boston',
  home_state: 'MA',
  home_country: 'US',
  school: 'MIT',
)
user.skip_confirmation!
user.save!


user = User.new(
  first_name: 'Cass',
  last_name: '??',
  email: 'cssndrx+mentor@gmail.com',
  password: 'testtest',
  role: 1,
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Raleigh',
  home_state: 'VA',
  home_country: 'US',
  school: 'MIT',
)
user.skip_confirmation!
user.save!


user = User.new(
  first_name: 'Cass',
  last_name: '??',
  email: 'cssndrx+coach@gmail.com',
  password: 'testtest',
  role: 2,
  password_confirmation: 'testtest',
  birthday: Date.new(1989, 12, 1),
  home_city: 'Raleigh',
  home_state: 'VA',
  home_country: 'US',
  school: 'MIT',
)
user.skip_confirmation!
user.save!


Setting.create(
  key: 'year',
  value: '2015',
)

Setting.create(
  key:'cutoff',
  value: Date.today.to_s,
)

Setting.create(
  key:'submissionOpen',
  value: '2015-04-14',
)

Setting.create(
  key:'submissionClose',
  value: '2015-04-23',
)


###

Setting.create(
  key:'quarterfinalScoresVisible',
  value: 'false',
)

Setting.create(
  key:'semifinalScoresVisible',
  value: 'false',
)

Setting.create(
  key:'finalScoresVisible',
  value: 'false',
)


######

Setting.create(
  key:'quarterfinalJudgingOpen',
  value: '2015-04-24',
)

Setting.create(
  key:'quarterfinalJudgingClose',
  value: '2015-05-03',
)

Setting.create(
  key:'semifinalJudgingOpen',
  value: '2015-05-05',
)

Setting.create(
  key:'semifinalJudgingClose',
  value: '2015-05-10',
)

Setting.create(
  key:'finalJudgingOpen',
  value: '2015-05-14',
)

Setting.create(
  key:'finalJudgingClose',
  value: '2015-05-16',
)

Setting.create(
  key:'studentRegistrationOpen',
  value: true,
)

Setting.create(
  key:'coachRegistrationOpen',
  value: true,
)

Setting.create(
  key:'mentorRegistrationOpen',
  value: true,
)

Setting.create(
  key:'judgeRegistrationOpen',
  value: true,
)

Setting.create(
  key:'todaysDateForTesting',
  value: '2015-05-06',
)


event = Event.create(
  name: 'Virtual Judging',
  location: 'Online',
  whentooccur: DateTime.new(2015, 07, 11, 20, 10, 0),
  description: 'Quarterfinals for everyone',
  organizer: 'Technovation',
)

event = Event.create(
  name: 'Northeast Quarterfinals',
  location: 'MIT',
  whentooccur: DateTime.new(2015, 07, 11, 20, 10, 0),
  description: 'Quarterfinals for the Northeast',
  organizer: 'Women in Science and Engineering',
)

event = Event.create(
  name: 'Bay Area Quarterfinals',
  location: 'Dropbox',
  whentooccur: DateTime.new(2015, 07, 11, 20, 10, 0),
  description: 'Quarterfinals for the Bay Area',
  organizer: 'Technovation',
)

category = Category.create(
  name: 'Health and fitness',
  year: '2015',
)

category = Category.create(
  name: 'Envrionment',
  year: '2015',
)

category = Category.create(
  name: 'Community values',
  year: '2015',
)


# Setting.create(
#   key: 'submissionOpen?',
#   value: true,
# )

# Setting.create(
#   key: 'submissionDeadline',
#   value: Date.today.to_s,
# )

ann = Announcement.create(
  title: "Welcome to Technovation's new site",
  post: "For the 2015 season, we're using a brand new website to organize, submit, and publish your projects. If you have any questions, please email us at info@technovationchallenge.org!",
  published: true,
)

Region.create(id: 0, region_name: "US/Canada", division: :hs, num_finalists: 3)
Region.create(id: 1, region_name: "Mexico/Central America/South America", division: :hs, num_finalists: 1)
Region.create(id: 2, region_name: "Europe/Australia/New Zealand/Asia", division: :hs, num_finalists: 1)
Region.create(id: 3, region_name: "Africa", division: :hs, num_finalists: 1)
Region.create(id: 4, region_name: "US/Canada", division: :ms, num_finalists: 2)
Region.create(id: 5, region_name: "Mexico/Central America/South America/Africa", division: :ms, num_finalists: 1)
Region.create(id: 6, region_name: "Europe/Australia/New Zealand/Asia", division: :ms, num_finalists: 1)
