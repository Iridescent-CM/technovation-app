desc "Fix counter_culture counter caches"
task fix_counts: :environment do
  SubmissionScore.counter_culture_fix_counts
end