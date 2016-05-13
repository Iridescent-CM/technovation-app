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
    if event.is_virtual?
      event.teams.joins(team_requests: :user)
                 .where(region: judge.judging_region)
    else
      event.teams
    end
  end

  def semifinal_teams
    if judge.semifinals_judge?
      team_list.joins(team_requests: :user).is_semi_finalist
    end
  end

  def final_teams
    if judge.finals_judge?
      team_list.joins(team_requests: :user).is_finalist
    end
  end

  class NoEvent
    def name; 'No event assigned'; end
    def is_virtual?; false; end
    def teams; []; end
  end
end
