require 'csv'

class ScoreImporting
  def initialize(file_path, score_repository, submission_repository, logger)
    @io_source = File.open(file_path)
    @score_repo = score_repository
    @sub_repo = submission_repository
    @logger = logger
  end

  def import_scores
    CSV.foreach(@io_source, headers: true) do |row|
      attrs = {
        "judge_profile_id" => 1836
      }.merge(row.to_h)

      attrs.each do |k, v|
        unless k.match(/_id/) or k.match(/_comment/)
          attrs[k] = v.to_i
        end
      end

      param = attrs.delete("team_submission_id")
      submission_id = @sub_repo.from_param(param).id
      attrs["team_submission_id"] = submission_id

      score = @score_repo.from_csv(attrs)
      score.complete!

      @logger.info(
        "Imported QF score for #{@sub_repo.name}##{submission_id}"
      )
    end
  end
end
