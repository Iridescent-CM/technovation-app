class SuspiciousSubmissionScores
  include Enumerable

  attr_reader :scores

  def initialize
    @scores = SubmissionScore.completed_too_fast_repeat_offense
  end

  def each(&block)
    @scores.each { |s| block.call(s) }
  end
end