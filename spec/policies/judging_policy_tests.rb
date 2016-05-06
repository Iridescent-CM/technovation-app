module JudgingPolicyTests
  def test_valid_judge(policy)
    expect(policy.new?).to be true
  end

  def test_judge_region_policies(judge, policy)
    judge.judging_region_id = 2
    expect(policy.new?).to be false

    judge.conflict_region_id = 1
    expect(policy.new?).to be false
  end

  def test_judge_event_policies(judge, policy)
    judge.event_id = 2
    expect(policy.new?).to be false
  end
end
