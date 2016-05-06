class CheckJudgingPolicy
  def self.call(judge, team)
    if team.nil?
      # stop-gap solution to deal with legacy code
      # that doesn't pass in the team
      judge.role == 'judge' || judge.judging?
    else
      judge_role = check_judge_role_policy(judge, team)
      judging_enabled = check_judging_enabled_policy(judge, team)

      judge_role || !!judging_enabled
      # `false || nil` returns nil,
      # so convert right-side truthy/falsy results
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
