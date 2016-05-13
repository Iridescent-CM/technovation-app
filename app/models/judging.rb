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

  def teams
    teams_for_round = send("#{current_round}_teams")
    eligible_teams = select_eligible_teams(teams_for_round)
    teams_for_country = select_teams_for_judge_country(eligible_teams)

    if event.is_virtual?
      select_random_teams_judged_the_same(teams_for_country)
    else
      teams_for_country
    end
  end

  def current_round
    setting.judgingRound
  end

  private
  def select_eligible_teams(teams)
    teams.reject { |team| team.judges.include?(judge) }
         .reject(&:ineligible?)
         .select(&:submission_eligible?)
  end

  def select_teams_for_judge_country(teams)
    if judge.home_country == 'BR'
      teams.select { |team| team.country == 'BR' }
    else
      teams.select { |team| team.country != 'BR' }
    end
  end

  def select_random_teams_judged_the_same(teams)
    teams.sort_by(&:num_rubrics)
         .select { |t| t.num_rubrics == teams[0].num_rubrics }
         .sample(3)
  end

  def no_round_teams
    []
  end

  def quarterfinal_teams
    if event.is_virtual?
      event.teams.where(region: judge.judging_region)
    else
      event.teams
    end
  end

  def semifinal_teams
    if judge.semifinals_judge?
      team_list.is_semi_finalist
    else
      []
    end
  end

  def final_teams
    if judge.finals_judge?
      team_list.is_finalist
    else
      []
    end
  end

  class NoEvent
    def is_virtual?
      false
    end

    def teams
      []
    end
  end
end
