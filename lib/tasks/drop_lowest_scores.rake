require "drop_lowest_scores"

desc "Drop the lowest current semifinals scores on submissions with 5 or more scores"
task drop_lowest_scores: :environment do
  TeamSubmission.current.semifinalist.find_each do |submission|
    DropLowestScores.(submission, STDOUT)
  end
end
