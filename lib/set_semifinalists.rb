class SetSemifinalists
  private
  attr_reader :filename

  public
  attr_reader :logger

  def initialize(filename)
    @filename = filename
    @logger = Rails.env.test? ? Logger.new("tmp/judging_tasks.log") : Logger.new($stdout)
  end

  def self.read(filename)
    new(filename)
  end

  def dry_run
    perform
  end

  def perform!
    perform(dry_run: false)
  end

  private
  def perform(opts = {})
    dry_run = opts.fetch(:dry_run) { true }
    fail_fast = !dry_run

    submission_ids_seen = []

    CSV.foreach(@filename, headers:true) do |row|
      begin
        submission_ids_seen << check_row(row)
      rescue => err
        raise if fail_fast
        @logger.error err.message
      end
    end

    begin
      check_database(submission_ids_seen)
    rescue => err
      raise if fail_fast
      @logger.error err.message
    end

    if !dry_run
      TeamSubmission.current.where(id: submission_ids_seen).find_each do |submission|
        if submission.semifinalist?
          @logger.info "NOT UPDATED: Team id=#{submission.team.id} #{submission.team.name} is already a semifinalist."
        else
          submission.update_column(:contest_rank, :semifinalist)
          @logger.info "UPDATED: Team id=#{submission.team.id} #{submission.team.name} is now a semifinalist."
        end
      end
    end
  end

  def check_row(row)
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

    submission.id
  end

  def check_database(ids_seen)
    other_semifinalists = TeamSubmission.current.semifinalist.where.not(id: ids_seen)
    if other_semifinalists.exists?
      other_semifinalists.each do |sub|
        @logger.error "Team id=#{sub.team.id} #{sub.team.name} not in csv, but marked as semifinalist in the database."
      end
      raise "DATA PROBLEM: Please ensure all semifinalists are included in csv, or set current semifinalists in the database back to quarterfinalists."
    end
  end

end
