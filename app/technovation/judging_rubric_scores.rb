class JudgingRubricScores
  include Enumerable

  def initialize
    @options = (0..5).map { |o| Option.new(o) }
  end

  def each(&block)
    @options.each(&block)
  end

  module Explain
    def self.call(score_value)
      Option.new(score_value).name
    end
  end

  private

  class Option < Struct.new(:value)
    def name
      case value
      when 0 then "0 – Incomplete – The submission is missing this piece."
      when 1 then "1 – Needs Improvement – Minimal work may have been done but is very incomplete."
      when 2 then "2 - Satisfactory – Some requirements met but missing big pieces."
      when 3 then "3 - Good – All requirements met and the work is able to be understood, but may have one or two major areas in need of improvement."
      when 4 then "4 - Excellent – All requirements are met, the work is excellent but may have a few minor areas that should be improved before bringing it to market."
      when 5 then "5 - Outstanding – The work is superior, well-polished and cohesive."
      end
    end
  end
end
