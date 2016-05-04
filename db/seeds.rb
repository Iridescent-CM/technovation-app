# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.find_or_create_by([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.find_or_create_by(name: 'Emanuel', city: cities.first)


Setting.find_or_create_by(
  key: 'year',
  value: '2015'
)

Setting.find_or_create_by(
  key: 'cutoff',
  value: Date.today.to_s
)

Submissions.open!("2015-04-14")
Submissions.close!("2015-04-23")

###

Setting.find_or_create_by(
  key: 'quarterfinalScoresVisible',
  value: 'false'
)

Setting.find_or_create_by(
  key: 'semifinalScoresVisible',
  value: 'false'
)

Setting.find_or_create_by(
  key: 'finalScoresVisible',
  value: 'false'
)

######

Setting.find_or_create_by(
  key: 'quarterfinalJudgingOpen',
  value: '2015-04-24'
)

Setting.find_or_create_by(
  key: 'quarterfinalJudgingClose',
  value: '2015-05-03'
)

Setting.find_or_create_by(
  key: 'semifinalJudgingOpen',
  value: '2015-05-05'
)

Setting.find_or_create_by(
  key: 'semifinalJudgingClose',
  value: '2015-05-10'
)

Setting.find_or_create_by(
  key: 'finalJudgingOpen',
  value: '2015-05-14'
)

Setting.find_or_create_by(
  key: 'finalJudgingClose',
  value: '2015-05-16'
)

Setting.find_or_create_by(
  key: 'studentRegistrationOpen',
  value: true
)

Setting.find_or_create_by(
  key: 'coachRegistrationOpen',
  value: true
)

Setting.find_or_create_by(
  key: 'mentorRegistrationOpen',
  value: true
)

Setting.find_or_create_by(
  key: 'judgeRegistrationOpen',
  value: true
)

Region.create(region_name: 'US/Canada', division: :hs, num_finalists: 3)
Region.create(region_name: 'Mexico/Central America/South America', division: :hs, num_finalists: 1)
Region.create(region_name: 'Europe/Australia/New Zealand/Asia', division: :hs, num_finalists: 1)
Region.create(region_name: 'Africa', division: :hs, num_finalists: 1)
Region.create(region_name: 'US/Canada', division: :ms, num_finalists: 2)
Region.create(region_name: 'Mexico/Central America/South America/Africa', division: :ms, num_finalists: 1)
Region.create(region_name: 'Europe/Australia/New Zealand/Asia', division: :ms, num_finalists: 1)
