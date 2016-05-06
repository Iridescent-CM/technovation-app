class CheckJudgingPolicy
  def self.call(judge, team)
    if team.nil?
      # temporary solution to deal with legacy code
      # that doesn't pass in the team
      judge.role == 'judge' || judge.judging?
    else
      can_judge_as_judge = check_judge_role_policy(judge, team)
      can_judge_as_judging_enabled = check_judging_enabled_policy(judge, team)

      can_judge_as_judge || !!can_judge_as_judging_enabled
      # can_judge_as_judging_enabled sometimes returns nil
      # `false || nil` will return nil
      # !! converts truthy/falsy variables
      # to their corresponding True/False
    end
  end

  private
  def self.check_judge_role_policy(judge, team)
    judge.role == 'judge' &&
      judge.conflict_region_id != team.region_id &&
        judge.judging_region_id == team.region_id &&
          judge.event_id == team.event_id
  end

  def self.check_judging_enabled_policy(judge, team)
    judge.judging? &&
      judge.team_requests.where(team_id: team.id).empty?
  end
end
