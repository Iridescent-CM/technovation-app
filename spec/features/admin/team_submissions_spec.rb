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

  scenario "list submissions on the admin page with the correct percentage completed" do
    within(page.find_all("tr")[1]) do
      expect(page).to have_link(
        "some app name",
        href: admin_team_submission_path(submission)
      )

      expect(page).to have_link(
        "Cool team",
        href: admin_team_path(submission.team)
      )

      expect(page).to have_content("8% completed")
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

    attach_file(
      "Business Canvas",
      Rails.root + "spec/support/fixtures/business_plan.pdf"
    )

    click_button "Save"

    expect(current_path).to eq(
      admin_team_submission_path(submission.reload)
    )

    expect(page).to have_content("A great description for the ages")

    expect(page).to have_link(
      "business_plan.pdf",
      href: submission.business_plan_url
    )
  end

  scenario "Add an image" do
    click_link "some app name"
    expect(page).to have_content("No images uploaded")

    click_link "Add image"
    expect(page).to have_button("Select image")

    # TODO: Groundwork for filestack specs
    # expect(page).to have_selector("div#__filestack-picker")
    # find("#fsp-fileUpload").set(Rails.root + "spec/support/fixtures/screenshot.jpg")

    click_button "Save"

    expect(current_path).to eq(
      admin_team_submission_path(submission.reload)
    )
  end
end
