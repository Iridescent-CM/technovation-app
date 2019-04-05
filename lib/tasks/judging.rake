namespace :judging do
  desc "Validate CSV for setting semifinalists"
  task :check_semifinalists, [:filename] => :environment do |t, args|
    set_semifinalists(args[:filename], dry_run: true)
  end

  desc "Set semifinalists from CSV"
  task :set_semifinalists, [:filename] => :environment do |t, args|
    logger.info "### DRY RUN: true"
    set_semifinalists(args[:filename], dry_run: true) # let's make sure the file gets checked
    logger.info "### DRY RUN: false"
    set_semifinalists(args[:filename], dry_run: false)
  end
end

def logger
  Rails.env.test? ? Logger.new("tmp/judging_tasks.log") : Logger.new($stdout)
end

def set_semifinalists(filename, opts = {})
  dry_run = opts.fetch(:dry_run) { true }

  submission_ids_seen = []

  CSV.foreach(filename, headers:true) do |row|
    unless row.headers.include?('team_id') && row.headers.include?('team_submission_id')
      raise "CSV FORMAT PROBLEM: Please ensure the csv contains a header row specifying both team_id and team_submission_id columns."
    end

    team_id = row['team_id']
    team_submission_id = row['team_submission_id']

    unless team_id && team_submission_id
      raise "DATA PROBLEM: Please ensure line #{$.} specifies a team_id and team_submission_id."
    end

    begin
      team = Team.find(team_id)
      submission = TeamSubmission.find(team_submission_id)
    rescue => err
      raise "DATA PROBLEM: On line #{$.}, team id=#{team_id} or submission id=#{team_submission_id} were not found\n" +
        "\t#{err}"
    end

    unless team.submission == submission
      raise "DATA PROBLEM: On line #{$.}, team and submission do not match.\n" +
        "\tTeam id=#{team_id} #{team.name} has submission id=#{team.submission.id} #{team.submission.app_name}, not submission id=#{submission.id} #{submission.app_name}"
    end

    submission_ids_seen << submission.id
  end

  other_semifinalists = TeamSubmission.current.semifinalist.where.not(id: submission_ids_seen)
  if other_semifinalists.exists?
    other_semifinalists.each do |sub|
      logger.info "Team id=#{sub.team.id} #{sub.team.name} not in csv, but marked as semifinalist in the database."
    end
    raise "DATA PROBLEM: Please ensure all semifinalists are included in csv, or set current semifinalists in the database back to quarterfinalists."
  end

  if !dry_run
    TeamSubmission.current.where(id: submission_ids_seen).find_each do |submission|
      if submission.semifinalist?
        logger.info "NOT UPDATED: Team id=#{submission.team.id} #{submission.team.name} is already a semifinalist."
      else
        submission.update_column(:contest_rank, :semifinalist)
        logger.info "UPDATED: Team id=#{submission.team.id} #{submission.team.name} is now a semifinalist."
      end
    end
  end
end
