class QuarterfinalScores
  def self.enable!
    setting.reset('quarterfinalScoresVisible', true)
  end

  def self.disable!
    setting.reset('quarterfinalScoresVisible', false)
  end

  private
  def self.setting
    Setting
  end
end
