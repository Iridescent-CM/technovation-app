require "rails_helper"

RSpec.feature "Dashboard season checklist" do
  scenario "Registration incomplete" do
    student = FactoryBot.create(:student, not_onboarded: true)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("please complete your registration")
    within(".checklist__registration") {
      expect(page).to have_css(".icon-circle-o")
      expect(page).to have_css(".icon-check-circle", visible: false)
    }
  end

  scenario "Registration complete" do
    student = FactoryBot.create(:student, :geocoded)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("registration is complete")
    within(".checklist__registration") {
      expect(page).to have_css(".icon-circle-o", visible: false)
      expect(page).to have_css(".icon-check-circle")
    }
  end

  scenario "Not on a team" do
    student = FactoryBot.create(:student)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("Join a team or register")
    within(".checklist__team") {
      expect(page).to have_css(".icon-circle-o")
      expect(page).to have_css(".icon-check-circle", visible: false)
    }
  end

  scenario "On a team" do
    student = FactoryBot.create(:student, :on_team, :geocoded)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("are on a team")
    within(".checklist__team") {
      expect(page).to have_css(".icon-circle-o", visible: false)
      expect(page).to have_css(".icon-check-circle")
    }
  end

  scenario "Submission locked from toggle" do
    SeasonToggles.team_submissions_editable = false

    student = FactoryBot.create(:student, :on_team, :geocoded)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("Uploading your app submission is not allowed")
    within(".checklist__submission") {
      expect(page).to have_css(".icon-lock")
      expect(page).to have_css(".icon-circle-o", visible: false)
      expect(page).to have_css(".icon-check-circle", visible: false)
    }
  end

  scenario "Submission locked from prerequisites" do
    SeasonToggles.team_submissions_editable!

    student = FactoryBot.create(:student, not_onboarded: true)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("Before you can start your app submission")
    within(".checklist__submission") {
      expect(page).to have_css(".icon-lock")
      expect(page).to have_css(".icon-circle-o", visible: false)
      expect(page).to have_css(".icon-check-circle", visible: false)
    }
  end

  scenario "Submission started" do
    SeasonToggles.team_submissions_editable!

    student = FactoryBot.create(:student, :on_team, :geocoded)
    sign_in(student)

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_content("Work as a team")
    within(".checklist__submission") {
      expect(page).to have_css(".icon-lock")
      expect(page).to have_css(".icon-circle-o", visible: false)
      expect(page).to have_css(".icon-check-circle", visible: false)
    }
  end
end
