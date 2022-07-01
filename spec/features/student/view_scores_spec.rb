require "rails_helper"

RSpec.feature "Students view scores" do
  before { SeasonToggles.display_scores_on! }

  scenario "Unfinished / unstarted submission" do
    submission = FactoryBot.create(:submission, :incomplete)

    sign_in(submission.team.students.sample)

    expect(page).to have_content("Thank you for your participation")
    expect(page).to have_content("Unfortunately, scores and certificates are not available for your team because your submission was incomplete")
  end
end
