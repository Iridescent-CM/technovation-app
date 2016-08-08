require "rails_helper"

RSpec.describe Student::MentorInvitesController do
  describe "POST #create" do
    let(:mentor) { FactoryGirl.create(:mentor) }
    let(:student) { FactoryGirl.create(:student, :on_team) }

    before do
      controller.set_cookie(:auth_token, student.auth_token)
      post :create, mentor_invite: {
                      team_id: student.team_id,
                      invitee_email: mentor.email,
                    }
    end

    it "sets an invite for the team and mentor" do
      invite = MentorInvite.last
      expect(invite.team).to eq(student.team)
      expect(invite.invitee).to eq(mentor)
    end

    it "redirects to the team page" do
      expect(response).to redirect_to(student_team_path(student.team))
    end
  end
end
