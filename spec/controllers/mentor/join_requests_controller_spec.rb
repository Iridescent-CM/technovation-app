require "rails_helper"

RSpec.describe Mentor::JoinRequestsController do
  describe "POST #create" do
    let(:team) { FactoryGirl.create(:team, members_count: 2) }
    let(:mentor) { FactoryGirl.create(:mentor) }

    before do
      sign_in(mentor)
      post :create, params: { team_id: team.id }
    end

    it "redirects gracefully on dupe" do
      join_request = JoinRequest.last

      expect {
        post :create, params: { team_id: team.id }
      }.not_to change { JoinRequest.count }

      expect(response).to redirect_to(mentor_join_request_path(join_request))
    end

    it "sends the correct email to all members" do
      mails = ActionMailer::Base.deliveries.last(2)

      expect(mails.flat_map(&:to)).to match_array(team.students.map(&:email))

      expect(mails.map(&:subject).sample).to eq(
        "A mentor has asked to join your team!"
      )

      bodies = mails.map(&:body)

      expect(bodies.sample.to_s).to include(
        "#{mentor.first_name} has asked to join your Technovation team as a mentor"
      )

      expect(bodies.sample.to_s).to include("Review This Request")

      url = student_team_url(
        team,
        host: ENV["HOST_DOMAIN"],
        port: ENV["HOST_DOMAIN"].split(":")[1]
      )

      expect(bodies.sample.to_s).to include("href=\"#{url}\"")
    end
  end
end
