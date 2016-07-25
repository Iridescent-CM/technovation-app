require "rails_helper"

RSpec.feature "Students request to join a team" do
  scenario "students already on a team don't see the link" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)
    expect(page).not_to have_link("Join a team")
  end

  scenario "students not on a team request to join an available team" do
    team = FactoryGirl.create(:team, creator_in: "Chicago, IL, US")
    student = FactoryGirl.create(:student, city: "Chicago",
                                           state_province: "IL",
                                           country: "US")

    sign_in(student)
    click_link "Join a team"
    click_link team.name
    click_button "Request to join #{team.name}"

    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request email was sent"
    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to eq("A student has requested to join your team!")
  end
end
