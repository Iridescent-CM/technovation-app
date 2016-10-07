require "rails_helper"

RSpec.describe Student::SignupsController do
  before do
    controller.set_cookie(:signup_token, SignupAttempt.create!(email: "invited@thanks.com").activation_token)
  end

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

    it "emails the welcome email to the student" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"
      mail = ActionMailer::Base.deliveries
      expect(mail.map(&:to)).to include([StudentAccount.last.email])
      expect(mail.map(&:subject)).to include("Welcome to Technovation #{Season.current.year}!")
    end

    it "registers the student to the current season" do
      expect(StudentAccount.last.seasons).to eq([Season.current])
    end
  end
end
