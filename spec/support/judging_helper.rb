module JudgingHelper
  def set_judging_round(round)
    @original_round = SeasonToggles.judging_round
    SeasonToggles.set_judging_round(round)
  end

  def reset_judging_round
    if @original_round.blank?
      SeasonToggles.set_judging_round(:off)
    else
      SeasonToggles.set_judging_round(@original_round)
    end
  end
end
