require "rails_helper"

RSpec.describe SubmissionScore do
  it "cannot be duplicated for the same submission and judge" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(team_id: team.id, integrity_affirmed: true)
    judge_profile = FactoryGirl.create(:judge_profile)

    second_team_submission = TeamSubmission.create!(team_id: team.id, integrity_affirmed: true)
    second_judge_profile = FactoryGirl.create(:judge_profile)

    SubmissionScore.create!(
      judge_profile_id: judge_profile.id,
      team_submission_id: team_submission.id,
    )

    expect {
      SubmissionScore.create!(
        judge_profile_id: judge_profile.id,
        team_submission_id: team_submission.id,
      )
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      SubmissionScore.create!(
        judge_profile_id: judge_profile.id,
        team_submission_id: second_team_submission.id,
      )

      SubmissionScore.create!(
        judge_profile_id: second_judge_profile.id,
        team_submission_id: team_submission.id,
      )
    }.not_to raise_error
  end

  it "reports completeness" do
    team = Team.create!(name: "A", description: "B", division: Division.senior)
    team_submission = TeamSubmission.create!(team_id: team.id, integrity_affirmed: true)
    judge_profile = FactoryGirl.create(:judge_profile)

    subscore = SubmissionScore.create!({
      team_submission: team_submission,
      judge_profile: judge_profile,
    })

    expect(subscore).not_to be_complete

    subscore.update_attributes({
      sdg_alignment: 0,
      evidence_of_problem: 0,
      problem_addressed: 0,
      app_functional: 0,

      demo_video: 0,
      business_plan_short_term: 0,
      business_plan_long_term: 0,
      market_research: 0,

      viable_business_model: 0,
      problem_clearly_communicated: 0,
      compelling_argument: 0,
      passion_energy: 0,

      pitch_specific: 0,
      business_plan_feasible: 0,
      submission_thought_out: 0,

      cohesive_story: 0,
      solution_originality: 0,
      solution_stands_out: 0,

      ideation_comment: "text",
      technical_comment: "text",
      entrepreneurship_comment: "text",
      pitch_comment: "text",
      overall_comment: "text",
    })

    expect(subscore).to be_complete
  end
end
