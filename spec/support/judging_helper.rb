module JudgingHelper
  def set_judging_round(round)
    @original_round =  ENV["JUDGING_ROUND"]
    ENV["JUDGING_ROUND"] = round
  end

  def reset_judging_round
    if @original_round.blank?
      ENV.delete("JUDGING_ROUND")
    else
      ENV["JUDGING_ROUND"] = @original_round
    end
  end
end
