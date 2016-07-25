require "rails_helper"

RSpec.feature "Students review requests from mentors" do
  let!(:team) { FactoryGirl.create(:team, creator_in: "Chicago, IL, US", members_count: 2) }
  let!(:mentor) { FactoryGirl.create(:mentor, city: "Chicago", state_province: "IL", country: "US") }

  before do
    ActionMailer::Base.deliveries.clear

    sign_in(mentor)
    visit new_mentor_join_request_path(team_id: team.id)
    click_button "Request to be a mentor for #{team.name}"
  end

  scenario "mentor request is emailed to team members" do
    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request email was sent"
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to match_array(team.student_emails)
    expect(mail.subject).to eq("A mentor has requested to join your team!")
    expect(mail.body.parts.last.to_s).to include("#{mentor.full_name} has requested to join your team as a mentor")
    expect(mail.body.parts.last.to_s).to include("You can review pending requests to join your team here:")
    expect(mail.body.parts.last.to_s).to include("href=\"#{student_team_url(team)}\"")
  end

  scenario "accept mentor requests on team page" do
    ActionMailer::Base.deliveries.clear

    sign_in(team.students.sample)
    click_link "My team"

    within(".pending_requests.mentors") do
      expect(page).to have_content(mentor.full_name)
      click_link "Approve"
    end

    expect(page).to have_css(".team_members", text: mentor.full_name)

    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request approval email was sent"
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq([JoinRequest.last.requestor_email])
    expect(mail.subject).to eq("Your request to mentor #{team.name} was accepted!")
    expect(mail.body.parts.last.to_s).to include("#{team.name} accepted your request to be a mentor!")
    expect(mail.body.parts.last.to_s).to include("href=\"#{mentor_team_url(team)}\"")
  end

  scenario "reject mentor requests on team page" do
    ActionMailer::Base.deliveries.clear

    sign_in(team.students.sample)
    click_link "My team"

    within(".pending_requests.mentors") do
      expect(page).to have_content(mentor.full_name)
      click_link "Reject"
    end

    expect(page).to have_css(".team_members", text: mentor.full_name)

    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "No join request rejection email was sent"
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq([JoinRequest.last.requestor_email])
    expect(mail.subject).to eq("Your request to mentor #{team.name} was rejected")
    expect(mail.body.parts.last.to_s).to include("#{team.name} has rejected your request to be a mentor.")
  end
end
