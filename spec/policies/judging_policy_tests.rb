module JudgingPolicyTests
  def test_valid_judge(policy)
    expect(policy.new?).to be true
  end

  def test_judge_region_policies(policy)
    valid_judging_region_id = policy.user.judging_region_id
    valid_judging_conflict_region_ids = policy.user.judging_conflict_region_ids

    policy.user.judging_region_id = 2
    expect(policy.new?).to be false

    policy.user.judging_region_id = valid_judging_region_id
    policy.user.conflict_region_ids = [1, 2]
    expect(policy.new?).to be false

    valid_judging_conflict_region_ids = policy.user.judging_conflict_region_ids
  end

  def test_judge_event_policies(policy)
    valid_event_id = policy.user.event_id

    policy.user.event_id = 2
    expect(policy.new?).to be false

    policy.user.event_id = valid_event_id
  end
end
