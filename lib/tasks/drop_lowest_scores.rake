VALID_QF_PHRASING = ["qf", "qfs", "quarterfinals", ":qf", ":qfs", ":quarterfinals"]
VALID_SF_PHRASING = ["sf", "sfs", "semifinals", ":sf", ":sfs", ":semifinals"]

desc "Drop the lowest current scores on submissions for a specified round and minimum score count, pass 'run' as the dry_run argument to turn dry run mode OFF."
task :drop_lowest_scores, [:round, :minimum_score_count, :dry_run] => :environment do |t, args|

  raise "Provide the judging round [qf or sf] as an argument" unless args[:round]
  raise "Provide the minimum score count for which the lowest score should be dropped" unless args[:minimum_score_count]

  round = args[:round]
  minimum_score_count = Integer(args[:minimum_score_count])
  dry_run = args[:dry_run] != 'run'

  if VALID_QF_PHRASING.include?(round.downcase)
    rank = :quarterfinalist
    round = :quarterfinals
  elsif VALID_SF_PHRASING.include?(round.downcase)
    rank = :semifinalist
    round = :semifinals
  else
    raise "Unknown round: #{round}"
  end

  puts "DRY RUN: #{dry_run ? 'on' : 'off'}"
  puts "Looking for #{rank} submissions with #{minimum_score_count} or more scores..."

  TeamSubmission
  .current
  .public_send(rank)
  .find_each do |submission|
    dropper = LowScoreDropping.new(
      submission,
      round: round,
      minimum_score_count: minimum_score_count
    )

    if dropper.already_dropped?
      puts "SKIP already dropped score for Submission##{submission.id}"
    elsif !dropper.has_enough_scores?
      puts "SKIP not enough scores for Submission##{submission.id}"
    else
      puts "DROP Submission##{submission.id} Team##{submission.team_id}"
      puts "\tRound average: #{dropper.average}"

      if !dry_run
        dropper.drop!
        puts "\tUpdated round average: #{dropper.average}"
      end
    end
  end

  if dry_run
    puts "Pass 'run' as the third task argument to turn off dry run and drop the lowest scores"
  end
end
