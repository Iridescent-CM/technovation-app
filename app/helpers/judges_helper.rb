module JudgesHelper
  def active_if_current_round(stage)
    'active' if Setting.judgingRound == stage
  end
end
