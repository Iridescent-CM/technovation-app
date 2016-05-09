class SelectJudgingTeams
  attr_reader :judge, :event, :teams

  def initialize(judge)
    @judge = judge
    @event = judge.event
    @teams = event.teams
  end

  def call
    if Setting.anyJudgingRoundActive?
      @teams = send("select_#{Setting.judgingRound}_teams")
      filter_for_eligible_teams
      filter_for_teams_based_on_judge_home_country

      select_random_teams_judged_the_same if event.is_virtual?
    end
  end

  private
  def select_quarterfinal_teams
    if event.is_virtual?
      @event = Event.virtual_for_current_season
      event.teams.where(region: judge.judging_region)
    else
      teams
    end
  end

  def select_semifinal_teams
    if judge.semifinals_judge?
      Team.is_semi_finalist
    else
      teams
    end
  end

  def select_final_teams
    if judge.finals_judge?
      Team.is_finalist
    else
      teams
    end
  end

  def filter_for_eligible_teams
    @teams = teams.reject { |team| team.judges.include?(judge) }
                  .reject(&:ineligible?)
                  .select(&:submission_eligible?)
  end

  def filter_for_teams_based_on_judge_home_country
    @teams = if judge.home_country == 'BR'
               teams.select { |team| team.country == 'BR' }
             else
               teams.select { |team| team.country != 'BR' }
             end
  end

  def select_random_teams_judged_the_same
    @teams = teams.sort_by(&:num_rubrics)
                  .select { |t| t.num_rubrics == @teams[0].num_rubrics }
                  .sample(3)
  end
end
