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
    round_teams = send("#{round}_teams") || []

    if event.is_virtual?
      team_list.least_judged(round_teams).sample(3)
    else
      round_teams
    end
  end

  private
  def no_round_teams; end

  def quarterfinal_teams
    teams = event.teams
    teams = teams.where(region: judge.judging_region) if event.is_virtual?
    eligible_teams_for_judge(teams)
  end

  def semifinal_teams
    teams_by_round(:semifinal)
  end

  def final_teams
    teams_by_round(:final)
  end

  def teams_by_round(round)
    if judge.send("#{round}s_judge?")
      eligible_teams_for_judge(team_list.send("is_#{round}ist"))
    end
  end

  def eligible_teams_for_judge(teams)
    teams.select { |t| t.eligible?(judge) }
  end

  class NoEvent
    def is_virtual?; false; end
    def teams; []; end
  end
end
