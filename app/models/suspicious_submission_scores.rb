class SuspiciousSubmissionScores
  include Enumerable

  attr_reader :scores

  def initialize
    @scores = SubmissionScore.current.complete.unapproved
  end

  def each(&block)
    @scores.each { |s| block.call(s) }
  end
end
