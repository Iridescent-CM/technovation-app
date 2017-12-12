require "rails_helper"

RSpec.feature "admin team submissions" do
  include ActionView::RecordIdentifier

  scenario "list submissions on the admin page" do
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    submission = FactoryBot.create(:submission, app_name: "some app name")
    submission.team.update(name: "Cool team")

    click_link "Submissions"

    within(page.find_all("tr")[1]) do
      expect(page).to have_content("some app name")
      expect(page).to have_content("Cool team")
      expect(page).to have_content("IL")
      expect(page).to have_content("United States")
    end
  end
end