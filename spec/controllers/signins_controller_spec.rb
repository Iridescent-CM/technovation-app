require "rails_helper"

RSpec.describe SigninsController do
  describe "POST #create" do
    it "records the account's login time" do
      student = FactoryGirl.create(:student)

      time = Time.new(2009, 1, 20, 9, 0, 0)

      Timecop.freeze(time) do
        post :create, params: {
          account: {
            email: student.email,
            password: "secret1234",
          },
        }

        expect(student.reload.last_logged_in_at).to eq(time)
      end
    end

    it "is case-insenstive for email" do
      FactoryGirl.create(:student, email: "CapiTalLettERS@gmail.com")

      post :create, params: {
        account: {
          email: "capitalletters@gmail.com",
          password: "secret1234",
        },
      }

      expect(response).to redirect_to(student_dashboard_path)
    end

    it "sends parent emails for past students registering for this season" do
      student = FactoryGirl.create(:student,
                                   :full_profile,
                                   password: "secret1234",
                                   parent_guardian_email: "parent2@parent2.com")

      student.account.update(seasons: [Season.current.year - 1])

      student.parental_consent.void!
      ActionMailer::Base.deliveries.clear

      post :create, params: {
        account: {
          email: student.email,
          password: "secret1234",
        },
      }

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no parent permission email sent"
      expect(mail.to).to eq(["parent2@parent2.com"])
      expect(mail.subject).to include("Your daughter needs permission")

      delete :destroy

      ActionMailer::Base.deliveries.clear

      post :create, params: { account: { email: student.email, password: student.password } }

      expect(ActionMailer::Base.deliveries).to be_empty, "another one was sent"
    end
  end
end
