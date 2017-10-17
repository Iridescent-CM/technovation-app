require "./lib/merge_ra_mentors"

task merge_ra_mentors: :environment do
  filepath = ENV.fetch("CSV_PATH") { "./lib/mentor_ra_merge.csv" }
  merger = MergeRAMentors.new(filepath, $stdout)
  merger.perform
end
