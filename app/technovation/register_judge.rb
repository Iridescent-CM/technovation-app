module RegisterJudge
  def self.call(judge_account, context)
    judge_account.save
  end

  def self.build(model, attributes)
    judge = model.new(attributes)
    judge.build_judge_profile if judge.judge_profile.blank?
    judge
  end
end
