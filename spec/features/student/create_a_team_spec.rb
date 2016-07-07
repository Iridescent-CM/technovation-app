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
end
