yesterday = Date.today - 1
tomorrow = Date.today + 1
day_after_close = tomorrow + 1

Setting.find_or_create_by(
  key: 'year',
  value: Date.today.year.to_s
)

Setting.find_or_create_by(
  key: 'cutoff',
  value: Date.today.to_s
)

Submissions.open!(yesterday.to_s)
Submissions.close!(tomorrow.to_s)

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
  value: day_after_close.to_s
)

Setting.find_or_create_by(
  key: 'quarterfinalJudgingClose',
  value: (day_after_close + 1).to_s
)

Setting.find_or_create_by(
  key: 'semifinalJudgingOpen',
  value: (day_after_close + 2).to_s
)

Setting.find_or_create_by(
  key: 'semifinalJudgingClose',
  value: (day_after_close + 3).to_s
)

Setting.find_or_create_by(
  key: 'finalJudgingOpen',
  value: (day_after_close + 4).to_s
)

Setting.find_or_create_by(
  key: 'finalJudgingClose',
  value: (day_after_close + 5).to_s
)

Setting.find_or_create_by(
  key: 'studentRegistrationOpen',
  value: 'true'
)

Setting.find_or_create_by(
  key: 'coachRegistrationOpen',
  value: 'true'
)

Setting.find_or_create_by(
  key: 'mentorRegistrationOpen',
  value: 'true'
)

Setting.find_or_create_by(
  key: 'judgeRegistrationOpen',
  value: 'true'
)

Region.create(region_name: 'US/Canada', division: :hs, num_finalists: 3)
Region.create(region_name: 'Mexico/Central America/South America', division: :hs, num_finalists: 1)
Region.create(region_name: 'Europe/Australia/New Zealand/Asia', division: :hs, num_finalists: 1)
Region.create(region_name: 'Africa', division: :hs, num_finalists: 1)
Region.create(region_name: 'US/Canada', division: :ms, num_finalists: 2)
Region.create(region_name: 'Mexico/Central America/South America/Africa', division: :ms, num_finalists: 1)
Region.create(region_name: 'Europe/Australia/New Zealand/Asia', division: :ms, num_finalists: 1)
