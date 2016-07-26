module RegisterJudge
  def self.call(judge_account, context)
    judge_account.save
  end

  def self.build(attributes)
    judge = JudgeAccount.new(attributes)
    judge.build_judge_profile if judge.judge_profile.blank?
    judge
  end
end
