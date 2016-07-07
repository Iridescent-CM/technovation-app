require "rails_helper"

RSpec.feature "Students create a team" do
  scenario "a student not on a team creates a team" do
    student = FactoryGirl.create(:student)
    sign_in(student)
    click_link "Create a team"

    fill_in "Name", with: "Girl Power"
    fill_in "Description", with: "We got... Girl Power!!!"

    click_button "Create team"

    expect(current_path).to eq(student_team_path(Team.last))
    expect(page).to have_css('.team_name', text: "Girl Power")
    expect(page).to have_css('.team_description', text: "We got... Girl Power!!!")
    expect(page).to have_css('.team_members', text: student.full_name)
  end

  scenario "a student on a team cannot create a team" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)
    expect(page).to have_link("Your team", href: student_team_path(Team.last))
    expect(page).not_to have_link("Create a team")
    expect(page).not_to have_link("Join a team")
  end
end
