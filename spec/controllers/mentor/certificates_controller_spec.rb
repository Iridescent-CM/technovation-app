require "rails_helper"

RSpec.describe Mentor::CertificatesController, type: :controller do
  describe "POST #create" do
    it "performs the background job for certificates" do
      mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)

      sign_in(mentor)

      expect(CertificateJob).to receive(:perform_later).with(
        mentor.account_id,
        mentor.current_teams.last.id.to_s,
      ).and_call_original

      post :create, params: { team_id: mentor.current_teams.last.id }
    end

    it "returns already existing certificates" do
      mentor = FactoryBot.create(
        :mentor,
        :on_team,
        :complete_submission
      )

      team = mentor.current_teams.last
      other_team = FactoryBot.create(:team)
      TeamRosterManaging.add(other_team, mentor)

      FillPdfs.(mentor.account, other_team)
      FillPdfs.(mentor.account, team)

      sign_in(mentor)

      expect(CertificateJob).not_to receive(:perform_later)

      post :create, params: { team_id: other_team.id }

      json = JSON.parse(response.body)
      certificate = mentor.current_certificates.find_by(team_id: other_team.id)
      expect(json['payload']['fileUrl']).to eq(certificate.file_url)
    end
  end
end
