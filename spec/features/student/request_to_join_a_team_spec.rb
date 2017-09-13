require "rails_helper"

RSpec.feature "Students request to join a team",
  vcr: { match_requests_on: [:method, :host] },
  no_es_stub: true do

  before { SeasonToggles.team_building_enabled! }

  scenario "students already on a team don't see the link" do
    student = FactoryGirl.create(:student, :on_team, not_onboarded: true)
    sign_in(student)
    expect(page).not_to have_link("Join a team")
  end

  context "a valid student requestor" do
    let!(:team) { FactoryGirl.create(:team) } # Default is in Chicago
    let!(:student) { FactoryGirl.create(:student, not_onboarded: true) } # Default Chicago

    before do
      ActionMailer::Base.deliveries.clear
      sign_in(student)
      visit new_student_join_request_path(team_id: team.id)
      click_button "Ask to join #{team.name}"
    end

    scenario "students not on a team request to join an available team" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero,
        "No join request email was sent"
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq("A student has asked to join your team!")
    end

    scenario "the requesting student can see their pending request" do
      within('.join_request') do
        expect(page).to have_content(team.name)
        expect(page).to have_content(team.primary_location)
        expect(page).to have_content(team.division_name.humanize)
        expect(page).to have_css("img.thumbnail-md[src*='#{team.team_photo_url}']")
      end

      expect(page).not_to have_link("Join a team")
    end

    scenario "student accepts the request" do
      ActionMailer::Base.deliveries.clear

      sign_out
      sign_in(team.students.sample)
      click_link "My team"
      click_link "approve"

      expect(ActionMailer::Base.deliveries.count).not_to be_zero,
        "No join request approval email was sent"
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([JoinRequest.last.requestor_email])
      expect(mail.subject).to eq("Your request to join #{team.name} was accepted!")
      expect(mail.body.to_s).to include("Hi #{JoinRequest.last.requestor_first_name}!")
      expect(mail.body.to_s).to include(
        "#{team.name} accepted your request to be a member!"
      )

      url = student_team_url(team,
                             host: ENV["HOST_DOMAIN"],
                             port: ENV["HOST_DOMAIN"].split(':')[1])

      expect(mail.body.to_s).to include("href=\"#{url}\"")
    end

    scenario "student declines the request" do
      ActionMailer::Base.deliveries.clear

      sign_out
      sign_in(team.students.sample)
      click_link "My team"
      click_link "decline"

      expect(ActionMailer::Base.deliveries.count).not_to be_zero,
        "No join request decline email was sent"

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([JoinRequest.last.requestor_email])
      expect(mail.subject).to eq("Your request to join #{team.name} was declined")
      expect(mail.body).to include("Hi #{JoinRequest.last.requestor_first_name},")
      expect(mail.body).to include(
        "#{team.name} has declined your request to be a member."
      )
    end
  end
end
