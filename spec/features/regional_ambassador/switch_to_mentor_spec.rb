require "rails_helper"

RSpec.feature "RAs switch to mentor mode" do

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_TO_JUDGE", any_args).and_return(true)
    allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(true)
  end

  scenario "an RA switches to mentor mode with a mentor profile" do
    ra = FactoryBot.create(:regional_ambassador, :approved)
    CreateMentorProfile.(ra)

    sign_in(ra)
    click_link "Mentor Mode"

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches to mentor mode without a mentor profile" do
    ra = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor Mode"

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches back to RA mode from mentor mode" do
    ra = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor Mode"
    click_link "RA mode"

    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end

  scenario "a mentor without an RA profile cannot switch to RA mode" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    sign_in(mentor)
    expect(page).not_to have_link("RA mode")

    visit regional_ambassador_dashboard_path
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "RAs with a judge profile can switch to judge mode" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

    sign_in(regional_ambassador)

    expect(regional_ambassador.is_a_judge?).to be_truthy

    click_link "Judge Mode"
    expect(current_path).to eq(judge_dashboard_path)

    click_link "Switch to RA mode"
    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end

  scenario "RAs without a judge profile do not see a judge mode link" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(regional_ambassador)

    expect(regional_ambassador.is_a_judge?).to be_falsey

    expect(page).not_to have_link("Judge Mode")
  end

  scenario "RAs do not see a judge mode link on their mentor dashboard" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

    sign_in(regional_ambassador)

    expect(regional_ambassador.is_a_judge?).to be_truthy

    click_link "Mentor Mode"
    expect(current_path).to eq(mentor_dashboard_path)

    expect(page).not_to have_link("Switch to Judge mode")
  end

  scenario "RAs without a judge profile cannot browse to judge profile" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(regional_ambassador)

    visit judge_dashboard_path

    expect(current_path).to eq(regional_ambassador_dashboard_path)
    expect(page).to have_content("You don't have permission to go there!")
  end
end

RSpec.feature "Config prevents RA switch to judge mode" do

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(false)
  end

  scenario "RAs with a judge profile do not see judge mode link" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

    sign_in(regional_ambassador)

    expect(regional_ambassador.is_a_judge?).to be_truthy
    expect(current_path).to eq(regional_ambassador_dashboard_path)

    expect(page).not_to have_link("Judge Mode")
  end

  scenario "RAs without a judge profile do not see a judge mode link" do
    regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(regional_ambassador)

    expect(regional_ambassador.is_a_judge?).to be_falsey
    expect(current_path).to eq(regional_ambassador_dashboard_path)

    expect(page).not_to have_link("Judge Mode")
  end
end
