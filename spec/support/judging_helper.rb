module JudgingHelper
  def set_judging_round(round)
    @original_round =  SeasonToggles.judging_round
    SeasonToggles.judging_round = round
  end

  def reset_judging_round
    if @original_round.blank?
      SeasonToggles.judging_round = :off
    else
      SeasonToggles.judging_round = @original_round
    end
  end
end
