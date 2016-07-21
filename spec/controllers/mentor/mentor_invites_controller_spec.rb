require "rails_helper"

RSpec.describe Mentor::MentorInvitesController do
  describe "PUT #update" do
    it "redirects to the mentor team page when the mentor account exists" do
      mentor = FactoryGirl.create(:mentor)
      invite = FactoryGirl.create(:mentor_invite, invitee_email: mentor.email)

      expect(put :update, id: invite.invite_token).to redirect_to mentor_team_path(invite.team)
    end
  end
end
