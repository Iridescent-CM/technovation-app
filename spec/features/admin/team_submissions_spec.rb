require "rails_helper"

RSpec.feature "admin team submissions" do
  let!(:submission) {
    FactoryBot.create(:submission, :senior)
  }

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    submission.update(app_name: "some app name")
    submission.team.update(name: "Cool team")

    click_link "Submissions"
  end

  scenario "list submissions on the admin page" do
    within(page.find_all("tr")[1]) do
      expect(page).to have_link(
        "some app name",
        href: admin_team_submission_path(submission)
      )

      expect(page).to have_link(
        "Cool team",
        href: admin_team_path(submission.team)
      )

      expect(page).to have_content("14% completed")
    end
  end

  scenario "View a specific submission" do
    click_link "some app name"

    expect(current_path).to eq(
      admin_team_submission_path(submission.reload)
    )

    expect(page).to have_content("Cool team")
  end

  scenario "Edit a specific submission" do
    click_link "some app name"
    click_link "Edit"

    fill_in "App description", with: "A great description for the ages"
    select "Swift or XCode", from: "Development platform"

    attach_file(
      "Business plan",
      Rails.root + "spec/support/fixtures/business_plan.pdf"
    )

    click_button "Save"

    expect(current_path).to eq(
      admin_team_submission_path(submission.reload)
    )

    expect(page).to have_content("A great description for the ages")

    expect(page).to have_content("Swift or XCode")

    expect(page).to have_link(
      "business_plan.pdf",
      href: submission.business_plan_url
    )
  end
end
