require "drop_lowest_scores"

desc "Drop the lowest current semifinals scores on submissions with 5 or more scores"
task drop_lowest_scores: :environment do
  EXCLUDE_TEAM_IDS = [
    6897,
    11569,
    7477,
    9506,
    7789,
    7616,
  ]

  TeamSubmission.where
    .not(team_id: EXCLUDE_TEAM_IDS)
    .current
    .semifinalist
    .find_each do |submission|
    DropLowestScores.(submission, STDOUT)
  end
end
