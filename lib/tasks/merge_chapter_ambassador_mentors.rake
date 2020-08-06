require "./lib/merge_chapter_ambassador_mentors"

task merge_chapter_ambassador_mentors: :environment do
  filepath = ENV.fetch("CSV_PATH") { "./lib/mentor_chapter_ambassador_merge.csv" }
  merger = MergeChapterAmbassadorMentors.new(filepath, $stdout)
  merger.perform
end
