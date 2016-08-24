require "rails_helper"

RSpec.describe Student::SignupsController do
  describe "POST #create for invited students" do
    it "assigns the invite to the new account by email" do
      invite = FactoryGirl.create(:team_member_invite,
                                  invitee_email: "invited@thanks.com")

      post :create, student_account: FactoryGirl.attributes_for(
        :student,
        email: "invited@thanks.com",
        student_profile_attributes: FactoryGirl.attributes_for(:student_profile),
      )

      expect(invite.reload.invitee).to eq(StudentAccount.last)
    end
  end

  describe "POST #create" do
    before do
      post :create, student_account: FactoryGirl.attributes_for(
        :student,
        student_profile_attributes: FactoryGirl.attributes_for(:student_profile),
      )
    end

    it "redirects to the student dashboard" do
      expect(response).to redirect_to(student_dashboard_path)
    end

    it "emails the consent form to the parent" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"
      mail = ActionMailer::Base.deliveries.last
      student = StudentAccount.last
      expect(mail.to).to eq([student.parent_guardian_email])
      expect(mail.body.parts.last.to_s).to include(
        "href=\"#{new_parental_consent_url(host: "www.example.com",
                                           token: student.consent_token)}\""
      )
    end

    it "registers the student to the current season" do
      expect(StudentAccount.last.seasons).to eq([Season.current])
    end
  end
end
