require "rails_helper"

RSpec.describe "Admin assigning a judge to a submission" do
  let(:team_submission) { FactoryBot.create(:submission, :complete) }
  let!(:score) { FactoryBot.create(
    :submission_score,
    :complete,
    team_submission: team_submission
  ) }

  let(:judge) { FactoryBot.create(:judge) }

  before do
    SeasonToggles.set_judging_round(:qf)

    sign_in(:admin)

    click_link "Scores"
    within("#team_submission_#{team_submission.id}") do
      find("a.view-details").click
    end

    fill_in "email", with: judge.email
    click_button "Assign Judge"
  end

  it "displays a success message" do
    expect(page).to have_content("This submission was successfully assigned")
  end

  it "assigns the submission to the judge" do
    expect(judge.scores.last.team_submission_id).to eq(team_submission.id)
  end
end
