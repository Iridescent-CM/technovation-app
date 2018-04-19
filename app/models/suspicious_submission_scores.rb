class SuspiciousSubmissionScores
  include Enumerable

  attr_reader :scores

  def initialize
    @scores = SubmissionScore.current_round.completed_too_fast_repeat_offense +
      SubmissionScore.current_round.seems_too_low
  end

  def each(&block)
    @scores.each { |s| block.call(s) }
  end
end