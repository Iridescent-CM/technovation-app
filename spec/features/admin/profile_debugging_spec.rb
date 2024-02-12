require "rails_helper"

RSpec.feature "When an admin is debugging a profile" do
  scenario "they view the background check status in the mentor debugging section a mentor based in the US" do
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

    expect(page).to have_content("Background check invitation not required in this country")
    expect(page).to have_css(".web-icon-text", text: "Clear")
  end

  scenario "they view the background check status in the mentor debugging section of mentor based in India" do
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

    expect(page).to have_content("Pending")
    expect(page).to have_css(".web-icon-text", text: "Invitation required")
  end

  scenario "they view the background check status in the mentor debugging section of a mentor not in a background check country" do
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

    expect(page).to have_content("Background check invitation not required in this country")
    expect(page).to have_content("Background check not required in this country")
  end

  scenario "they view the background check status in the ChA debugging section a ChA based in the US" do
    chapter_ambassador = FactoryBot.create(
      :chapter_ambassador,
      :approved
    )

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{chapter_ambassador.account_id}") do
      click_link "view"
    end

    expect(page).to have_content("Background check invitation not required in this country")
    expect(page).to have_css(".web-icon-text", text: "Clear")
  end

  scenario "they view the background check status in the ChA debugging section a ChA not based in the US" do
    chapter_ambassador = FactoryBot.create(
      :chapter_ambassador,
      :brazil,
      :approved
    )

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{chapter_ambassador.account_id}") do
      click_link "view"
    end

    expect(page).to have_content("Background check invitation not required in this country")
    expect(page).to have_content("Background check not required in this country")
  end
end
