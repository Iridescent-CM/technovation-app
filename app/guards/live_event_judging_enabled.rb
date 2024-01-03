module LiveEventJudgingEnabled
  def self.call(judge)
    SeasonToggles.quarterfinals? and judge.live_event?
  end
end
