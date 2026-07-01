namespace :judging do
  desc "Set contest rank by submission ID(s)"
  task :set_contest_rank, [:rank] => :environment do |t, args|
    puts Judging::SetContestRank.new(
      rank: args[:rank],
      submission_ids: args.extras
    ).call
  end
end
