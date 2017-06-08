desc "Import manual scores from a given CSV_SOURCE"
task import_scores: :environment do
  importing = ScoreImporting.new(
    ENV.fetch("CSV_SOURCE"),
    SubmissionScore,
    TeamSubmission,
    Rails.logger
  )

  importing.import_scores
end
