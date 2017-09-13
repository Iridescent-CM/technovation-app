require "rails_helper"

RSpec.describe Student::SignupsController do
  before do
    set_signup_token({
      email: "invited@thanks.com",
      password: "secret1234",
    })
  end

  describe "POST #create for invited students" do
    it "assigns the invite to the new account by email" do
      invite = FactoryGirl.create(
        :team_member_invite,
        invitee_email: "invited@thanks.com"
      )

      post :create, params: {
        student_profile: FactoryGirl.attributes_for(:student).merge(
          account_attributes: FactoryGirl.attributes_for(
            :account,
            email: "invited@thanks.com"
          )
        )
      }

      expect(invite.reload.invitee).to eq(StudentProfile.last)
    end
  end

  describe "POST #create" do
    before do
      post :create, params: {
        student_profile: FactoryGirl.attributes_for(:student).merge(
          account_attributes: FactoryGirl.attributes_for(:account)
        )
      }
    end

    it "redirects to the student dashboard" do
      expect(response).to redirect_to(student_dashboard_path)
    end

    it "emails the welcome email to the student" do
      expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"
      mail = ActionMailer::Base.deliveries
      expect(mail.map(&:to)).to include([Account.last.email])
      expect(mail.map(&:subject)).to include(
        "Welcome to Technovation #{Season.current.year}!"
      )
    end

    it "registers the student to the current season" do
      expect(Account.last.seasons).to eq([Season.current.year])
    end
  end
end
