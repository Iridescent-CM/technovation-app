require "rails_helper"

RSpec.describe Mentor::JoinRequestsController do
  describe "POST #create" do
    # TODO: Creating students with parental consents is requiring this eager let
    let!(:team) { FactoryGirl.create(:team, members_count: 2) }
    let(:mentor) { FactoryGirl.create(:mentor) }

    before do
      sign_in(mentor)
    # TODO: Creating students with parental consents is requiring this deliveries purge
      ActionMailer::Base.deliveries.clear
      post :create, params: { team_id: team.id }
    end

    it "emails the team members" do
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to match_array(team.students.flat_map(&:email))
    end

    it "sends the correct email" do
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq("A mentor has requested to join your team!")
      expect(mail.body.to_s).to include("#{mentor.first_name} has requested to join your Technovation team as a mentor")
      expect(mail.body.to_s).to include("Review This Request")

      url = student_team_url(
        team,
        host: ENV["HOST_DOMAIN"],
        port: ENV["HOST_DOMAIN"].split(":")[1]
      )

      expect(mail.body.to_s).to include("href=\"#{url}\"")
    end
  end
end
