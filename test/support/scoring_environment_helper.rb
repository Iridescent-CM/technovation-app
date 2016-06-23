module ScoringEnvironmentHelper
  def create_test_scoring_environment
    ideation = { category: "Ideation",
                 expertise: true,
                 questions: [{ label: "Was the idea good?",
                               values: [{ label: "No", value: 0 },
                                        { label: "Yes", value: 3 }] }] }

    technology = { category: "Technology",
                   expertise: true,
                   questions: [{ label: "Was the tech good?",
                                 values: [{ label: "No", value: 0 },
                                          { label: "Yes", value: 7 }] }] }

    business = { category: "Business",
                 expertise: true,
                 questions: [{ label: "Was the biz good?",
                               values: [{ label: "No", value: 0 },
                                        { label: "Yes", value: 5 }] }] }

    bonus = { category: "Bonus", expertise: false }

    @rubric ||= CreateScoringRubric.([ideation, technology, business, bonus])

    submission
  end

  def submission
    return @submission if defined?(@submission)
    team = Team.create!(name: "Test team",
                        description: "Real creative name",
                        division: Division.high_school,
                        region: Region.find_or_create_by(name: "US/Canada"))
    @submission = team.submissions.create!(submission_attributes)
  end
end
