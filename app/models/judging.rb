class Judging
  private
  attr_reader :judge, :event, :team_list, :setting

  public
  def initialize(judge = nil, team_list = Team, setting = Setting)
    @judge = judge
    @event = !!judge ? judge.event : nil
    @setting = setting
    @team_list = team_list
  end

  def teams
    case current_round
    when 'no_round'
      []
    when 'semifinal'
      judge.semifinals_judge? ? team_list.is_semi_finalist : []
    else
      event.teams
    end
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
