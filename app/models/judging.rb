class Judging
  private
  attr_reader :team_list
  attr_reader :setting

  public
  attr_reader :judge
  attr_reader :event

  def initialize(judge, team_list = Team, setting = Setting)
    @judge = judge
    @event = judge.event || NoEvent.new
    @setting = setting
    @team_list = team_list
  end

  def teams(round = setting.judgingRound)
    selected = teams_by_round(round).select { |t| t.eligible?(judge) }

    if event.is_virtual?
      team_list.least_judged(selected).sample(3)
    else
      selected
    end
  end

  private
  def teams_by_round(round)
    case round.to_s
    when 'no_round'; []
    when 'quarterfinal'; quarterfinal_teams
    else; send("#{round}_teams") || []
    end
  end

  def quarterfinal_teams
    event.is_virtual? ? event.teams.includes(:members).where(region: judge.judging_region) : event.teams
  end

  def semifinal_teams
    team_list.includes(:members).is_semi_finalist if judge.semifinals_judge?
  end

  def final_teams
    team_list.includes(:members).is_finalist if judge.finals_judge?
  end

  class NoEvent
    def is_virtual?; false; end
    def teams; []; end
  end
end
