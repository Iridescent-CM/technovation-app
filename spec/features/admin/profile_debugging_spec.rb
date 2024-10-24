require "rails_helper"

RSpec.feature "When an admin is debugging a profile" do
  scenario "they view the background check status in the mentor debugging section of an onboarded mentor based in the US" do
    mentor = FactoryBot.create(
      :mentor,
      :los_angeles,
      :onboarded
    )

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{mentor.account_id}") do
      click_link "view"
    end

    expect(page).to have_css(".web-icon-text", text: "Clear")
  end

  scenario "they view the background check status of a mentor based in India who has not completed their background check invitation" do
    mentor = FactoryBot.create(
      :mentor,
      :india,
      :onboarded
    )

    mentor.background_check.destroy

    FactoryBot.create(
      :background_check,
      report_id: nil,
      candidate_id: nil,
      invitation_status: :pending,
      internal_invitation_status: :invitation_sent,
      status: :invitation_required,
      account: mentor.account
    )

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{mentor.account_id}") do
      click_link "view"
    end

    expect(page).to have_content("Invitation status: Pending")
  end

  scenario "they view the background check status of a mentor not in a background check country" do
    mentor = FactoryBot.create(
      :mentor,
      :brazil,
      :onboarded
    )

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{mentor.account_id}") do
      click_link "view"
    end

    expect(page).to have_content("Background check not required in this country")
  end

  scenario "they view the background check invitation status of a mentor based in India who has not requested a background check invitation" do
    mentor = FactoryBot.create(
      :mentor,
      :india
    )

    mentor.background_check.destroy
    mentor.reload

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{mentor.account_id}") do
      click_link "view"
    end

    expect(page).to have_content("Incomplete")
    expect(page).to have_content("Invitation not sent")
  end
end
