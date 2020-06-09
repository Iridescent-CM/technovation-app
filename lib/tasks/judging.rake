namespace :judging do
  desc "Set contest rank by submission ID(s)"
  task :set_contest_rank, [:rank] => :environment do |t, args|
    puts TeamSubmission.current.where(id: args.extras).update_all(contest_rank: args[:rank])
  end
end