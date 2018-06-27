require "rails_helper"

RSpec.feature "Admins view student profile pages" do
  scenario "viewing a new student" do
    student = FactoryBot.create(:student)

    sign_in(:admin)

    click_link "Participants"
    within(".datagrid") { click_link "view" }

    expect(current_path).to eq(admin_participant_path(student.account))
    expect(page).to have_css(
      ".flag.flag--season.flag-season--new",
      text: "New student"
     )
  end

  scenario "viewing a past student" do
    student = FactoryBot.create(:student, :past)

    sign_in(:admin)

    click_link "Participants"
    visit admin_participant_path(student.account)

    expect(page).to have_css(
      ".flag.flag--season.flag-season--past",
      text: "Past student"
     )
  end

  scenario "viewing a returning student" do
    student = FactoryBot.create(:student, :returning)

    sign_in(:admin)

    click_link "Participants"
    visit admin_participant_path(student.account)

    expect(page).to have_css(
      ".flag.flag--season.flag-season--returning",
      text: "Returning student"
     )
  end
end