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
end
