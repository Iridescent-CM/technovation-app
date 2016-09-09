require "rails_helper"

RSpec.feature "Students request to join a team" do
  scenario "students already on a team don't see the link" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)
    within("nav.profile") { expect(page).not_to have_link("Join a team") }
  end

  context "a valid student requestor" do
    let!(:team) { FactoryGirl.create(:team, creator_in: "Chicago, IL") }
    let!(:student) { FactoryGirl.create(:student, geocoded: "60647") }

    before do
      ActionMailer::Base.deliveries.clear
      sign_in(student)
      within("nav.profile") { click_link "Join a team" }
      click_link team.name
      click_button "Request to join #{team.name}"
    end

    scenario "students not on a team request to join an available team" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request email was sent"
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq("A student has requested to join your team!")
    end

    scenario "student accepts the request" do
      ActionMailer::Base.deliveries.clear

      sign_out
      sign_in(team.students.sample)
      click_link "My team"
      click_link "approve"

      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request approval email was sent"
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([JoinRequest.last.requestor_email])
      expect(mail.subject).to eq("Your request to join #{team.name} was accepted!")
      expect(mail.body.parts.last.to_s).to include("#{team.name} accepted your request to be a member!")
      expect(mail.body.parts.last.to_s).to include("href=\"#{student_team_url(team)}\"")
    end

    scenario "student declines the request" do
      ActionMailer::Base.deliveries.clear

      sign_out
      sign_in(team.students.sample)
      click_link "My team"
      click_link "decline"

      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request decline email was sent"
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([JoinRequest.last.requestor_email])
      expect(mail.subject).to eq("Your request to join #{team.name} was declined")
      expect(mail.body.parts.last.to_s).to include("#{team.name} has declined your request to be a member.")
    end
  end
end
