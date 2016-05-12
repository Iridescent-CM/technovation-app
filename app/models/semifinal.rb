class Semifinal
  def teams_to_judge(judge)
    judge.semifinals_judge? ? Team.is_semi_finalist : []
  end
end
