require 'csv'

class ScoreImporting
  def initialize(import_options)
    @io_source = File.open(import_options.fetch(:csv_path))

    @judge_id = import_options.fetch(:judge_id) { nil }
    @judging_round = import_options.fetch(:judging_round) { "quarterfinals" }
    @score_repo = import_options.fetch(:scores) { SubmissionScore }
    @sub_repo = import_options.fetch(:submissions) { TeamSubmission }
    @account_repo = import_options.fetch(:accounts) { Account }
    @logger = import_options.fetch(:logger) { Logger.new('/dev/null') }
  end

  def import_scores
    CSV.foreach(@io_source, headers: true) do |row|
      attrs = initialize_attrs(row)

      attrs["team_submission_id"] = find_sub_id_from_friendly(attrs)
      attrs["judge_profile_id"] = find_judge_profile_id(attrs)
      attrs["round"] = find_judging_round

      create_complete_score_from_csv(attrs)
      log_complete_score
    end
  end

  private
  def initialize_attrs(row)
    attrs = row.to_h
    attrs.each do |k, v|
      unless k.match(/_id/) or k.match(/_comment/) or k.match(/_email/)
        attrs[k] = v.to_i
      end
    end
    attrs
  end

  def find_sub_id_from_friendly(attrs)
    param = attrs.delete("team_submission_id")
    @sub_repo.from_param(param).id
  end

  def find_judge_profile_id(attrs)
    if judge_email = attrs.delete("judge_email")
      @account_repo.find_judge_profile_id_by_email(judge_email)
    else
      @judge_id
    end
  end

  def find_judging_round
    @score_repo.judging_round(@judging_round)
  end

  def create_complete_score_from_csv(attrs)
    @score = @score_repo.from_csv(attrs)
    @score.complete!
  end

  def log_complete_score
    info = "Imported #{@score.round}"
    info += " score (#{@score.total})"
    info += " for #{@sub_repo.name}"
    info += " #{@score.team_submission.app_name}"
    @logger.info(info)
  end
end
