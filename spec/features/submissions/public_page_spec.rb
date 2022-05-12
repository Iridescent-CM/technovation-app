require "rails_helper"

RSpec.feature "Public submission pages" do
  scenario "past season" do
    submission = FactoryBot.create(:submission, :past_season)
    visit project_path(submission)
    expect(page).to have_content(submission.team_name)
  end

  scenario "current season" do
    submission = FactoryBot.create(:submission)
    visit project_path(submission)
    expect(page).to have_content(submission.team_name)
  end

  scenario "incomplete" do
    submission = FactoryBot.create(:submission, :incomplete)
    visit project_path(submission)
    expect(page).to have_content(submission.team_name)
  end
end
