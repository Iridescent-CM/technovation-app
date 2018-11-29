require "rails_helper"

RSpec.describe "Public submission pages" do
  it "works for past seasons" do
    submission = FactoryBot.create(:submission, :past_season)
    visit app_path(submission)
    expect(page).to have_content(submission.team_name)
  end

  it "works for current seasons" do
    submission = FactoryBot.create(:submission)
    visit app_path(submission)
    expect(page).to have_content(submission.team_name)
  end

  it "works for incomplete submissions" do
    submission = FactoryBot.create(:submission, :incomplete)
    visit app_path(submission)
    expect(page).to have_content(submission.team_name)
  end
end
