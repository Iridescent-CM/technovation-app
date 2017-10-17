require "./lib/merge_ra_mentors"

task merge_ra_mentors: :environment do
  filepath = ARGV[0] || "./lib/tasks/mergers.csv"
  mergers = Mergers.new(filepath)
  MergeRAMentors.(mergers)
end
