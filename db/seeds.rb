# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Setting.create(
  key: 'year',
  value: '2015'
)

Setting.create(
  key: 'cutoff',
  value: Date.today.to_s
)

Setting.create(
  key: 'submissionOpen',
  value: '2015-04-14'
)

Setting.create(
  key: 'submissionClose',
  value: '2015-04-23'
)

###

Setting.create(
  key: 'quarterfinalScoresVisible',
  value: 'false'
)

Setting.create(
  key: 'semifinalScoresVisible',
  value: 'false'
)

Setting.create(
  key: 'finalScoresVisible',
  value: 'false'
)

######

Setting.create(
  key: 'quarterfinalJudgingOpen',
  value: '2015-04-24'
)

Setting.create(
  key: 'quarterfinalJudgingClose',
  value: '2015-05-03'
)

Setting.create(
  key: 'semifinalJudgingOpen',
  value: '2015-05-05'
)

Setting.create(
  key: 'semifinalJudgingClose',
  value: '2015-05-10'
)

Setting.create(
  key: 'finalJudgingOpen',
  value: '2015-05-14'
)

Setting.create(
  key: 'finalJudgingClose',
  value: '2015-05-16'
)

Setting.create(
  key: 'studentRegistrationOpen',
  value: true
)

Setting.create(
  key: 'coachRegistrationOpen',
  value: true
)

Setting.create(
  key: 'mentorRegistrationOpen',
  value: true
)

Setting.create(
  key: 'judgeRegistrationOpen',
  value: true
)

Setting.create(
  key: 'todaysDateForTesting',
  value: '2015-05-06'
)

Region.create(id: 0, region_name: 'US/Canada', division: :hs, num_finalists: 3)
Region.create(id: 1, region_name: 'Mexico/Central America/South America', division: :hs, num_finalists: 1)
Region.create(id: 2, region_name: 'Europe/Australia/New Zealand/Asia', division: :hs, num_finalists: 1)
Region.create(id: 3, region_name: 'Africa', division: :hs, num_finalists: 1)
Region.create(id: 4, region_name: 'US/Canada', division: :ms, num_finalists: 2)
Region.create(id: 5, region_name: 'Mexico/Central America/South America/Africa', division: :ms, num_finalists: 1)
Region.create(id: 6, region_name: 'Europe/Australia/New Zealand/Asia', division: :ms, num_finalists: 1)
