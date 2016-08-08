require "rails_helper"

RSpec.describe Mentor::JoinRequestsController do
  describe "POST #create" do
    let(:team) { FactoryGirl.create(:team, members_count: 2) }
    let(:mentor) { FactoryGirl.create(:mentor) }

    let(:mail) { ActionMailer::Base.deliveries.last }

    before do
      sign_in(mentor)
      post :create, team_id: team.id
    end

    it "emails the team members" do
      expect(mail.to).to match_array(team.student_emails)
    end

    it "sends the correct email" do
      expect(mail.subject).to eq("A mentor has requested to join your team!")
      expect(mail.body.parts.last.to_s).to include("#{mentor.full_name} has requested to join your team as a mentor")
      expect(mail.body.parts.last.to_s).to include("You can review pending requests to join your team here:")
      expect(mail.body.parts.last.to_s).to include("href=\"#{student_team_url(team, host: "www.example.com")}\"")
    end
  end
end
