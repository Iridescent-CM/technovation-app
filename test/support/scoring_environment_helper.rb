module ScoringEnvironmentHelper
  def create_test_scoring_environment
    CreateScoringRubric.([{ category: "Ideation",
                            attributes: [{ label: "Was the idea good?",
                                            values: [{ label: "No", value: 0 },
                                                    { label: "Yes", value: 3 }] }] },
                          { category: "Technology",
                            attributes: [{ label: "Was the tech good?",
                                          values: [{ label: "No", value: 0 },
                                                    { label: "Yes", value: 7 }] }] },
                          { category: "Business",
                            attributes: [{ label: "Was the biz good?",
                                          values: [{ label: "No", value: 0 },
                                                    { label: "Yes", value: 5 }] }] }])

    submission
  end

  def submission
    return @submission if defined?(@submission)
    team = Team.create!(name: "Test team",
                        description: "Real creative name",
                        division: Division.high_school,
                        region: Region.find_or_create_by(name: "US/Canada"))
    @submission = team.submissions.create!
  end
end
