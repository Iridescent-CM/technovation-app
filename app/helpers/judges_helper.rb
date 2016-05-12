module JudgesHelper
  def active_if_current_round(stage)
    'active' if Judging.current_round == stage
  end
end
