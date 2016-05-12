class Judging
  private
  attr_reader :judge, :event, :team_list, :setting

  public
  def initialize(judge, team_list = Team, setting = Setting)
    @judge = judge
    @event = judge.event
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

  def current_round
    setting.judgingRound
  end
end
