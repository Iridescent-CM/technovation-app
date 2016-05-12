class Judging
  private
  attr_reader :judge, :event, :setting

  public
  def initialize(judge = nil, setting = Setting)
    @judge = judge
    @event = !!judge ? judge.event : nil
    @setting = setting
  end

  def teams(stage)
    !!event ? event.teams : []
  end

  def open!(stage, date)
    setting.reset("#{stage}JudgingOpen", date)
  end

  def close!(stage, date)
    setting.reset("#{stage}JudgingClose", date)
  end

  def current_round
    setting.judgingRound
  end

  class << self
    def open!(stage, date)
      instance.open!(stage, date)
      true
    end

    def close!(stage, date)
      instance.close!(stage, date)
      true
    end

    def current_round
      instance.current_round
    end

    private
    def instance
      new
    end
  end
end
