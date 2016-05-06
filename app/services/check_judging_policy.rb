class CheckJudgingPolicy
  def self.call(judge, team)
    if team.nil?
      # temporary solution to deal with legacy code
      # that doesn't pass in the team
      judge.role == 'judge' || judge.judging?

    elsif judge.role == 'judge'
      !!check_judge_role_policy(judge, team)
    elsif judge.judging?
      !!check_judging_enabled_policy(judge, team)
    else
      false
    end
  end

  private
  def self.check_judge_role_policy(judge, team)
    judge.conflict_region_id != team.region_id &&
      judge.judging_region_id == team.region_id &&
        judge.event_id == team.event_id
  end

  def self.check_judging_enabled_policy(judge, team)
    check_judge_role_policy(judge, team) &&
      judge.team_requests.where(team_id: team.id).empty?
  end
end
