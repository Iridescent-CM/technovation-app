desc "Import manual scores from a given CSV_SOURCE"
task import_scores: :environment do
  email = ENV.fetch("CSV_JUDGE_EMAIL")
  judge = Account.find_by(email: email).judge_profile

  if judge.nil?
    raise "no judge found with email #{email}"
  end

  logging = ENV.fetch("CSV_LOGGING") { "stdout" }

  if logging == "stdout"
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
  elsif logging == "none"
    logger = Logger.new("/dev/null")
  else
    logger = Rails.logger
  end

  importing = ScoreImporting.new(
    csv_path: ENV.fetch("CSV_SOURCE"),
    judge_id: judge.id,
    judging_round: ENV.fetch("CSV_JUDGING_ROUND"),
    logger: logger,
  )

  importing.import_scores
end
