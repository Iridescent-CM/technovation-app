require "rails_helper"

RSpec.describe SigninsController do
  describe "POST #create" do
    it "records the account's login time" do
      student = FactoryBot.create(:student)

      time = Time.new(2009, 1, 20, 9, 0, 0)

      Timecop.freeze(time) do
        post :create, params: {
          account: {
            email: student.email,
            password: "secret1234"
          }
        }

        expect(student.reload.last_logged_in_at.to_i).to eq(time.to_i)
      end
    end

    it "is case-insenstive for email" do
      FactoryBot.create(
        :student,
        account: FactoryBot.create(
          :account,
          email: "CapiTalLettERS@gmail.com"
        )
      )

      post :create, params: {
        account: {
          email: "capitalletters@gmail.com",
          password: "secret1234"
        }
      }

      expect(response).to redirect_to(student_dashboard_path)
    end

    it "ignores dots" do
      FactoryBot.create(
        :student,
        account: FactoryBot.create(
          :account,
          email: "dots.ignored@gmail.com"
        )
      )

      post :create, params: {
        account: {
          email: "dotsigno.red@gmail.com",
          password: "secret1234"
        }
      }

      expect(response).to redirect_to(student_dashboard_path)
    end

    it "increments failed attempts for a wrong password" do
      student = FactoryBot.create(:student)

      expect {
        post :create, params: {
          account: {
            email: student.email,
            password: "wrong-password"
          }
        }
      }.to change { student.account.reload.failed_attempts }.by(1)

      expect(response).to render_template(:new)
      expect(flash.now[:error]).to eq(I18n.t("controllers.signins.create.error"))
    end

    it "does not increment failed attempts for an unknown email" do
      post :create, params: {
        account: {
          email: "unknown@example.com",
          password: "wrong-password"
        }
      }

      expect(response).to render_template(:new)
      expect(flash.now[:error]).to eq(I18n.t("controllers.signins.create.error"))
    end

    it "locks the account after too many failed attempts" do
      student = FactoryBot.create(:student)
      student.account.update!(failed_attempts: Account::MAX_FAILED_ATTEMPTS - 1)

      post :create, params: {
        account: {
          email: student.email,
          password: "wrong-password"
        }
      }

      expect(student.account.reload.locked?).to be(true)
      expect(flash.now[:error]).to eq(I18n.t("controllers.signins.create.error"))
    end

    it "rejects sign-in for a locked account" do
      student = FactoryBot.create(:student)
      student.account.update!(
        failed_attempts: Account::MAX_FAILED_ATTEMPTS,
        locked_at: 5.minutes.ago
      )

      post :create, params: {
        account: {
          email: student.email,
          password: "secret1234"
        }
      }

      expect(response).to render_template(:new)
      expect(flash.now[:error]).to eq(I18n.t("controllers.signins.create.locked"))
      expect(student.account.reload.failed_attempts).to eq(Account::MAX_FAILED_ATTEMPTS)
    end

    it "resets failed attempts after a successful sign-in" do
      student = FactoryBot.create(:student)
      student.account.update!(failed_attempts: 3, locked_at: nil)

      post :create, params: {
        account: {
          email: student.email,
          password: "secret1234"
        }
      }

      expect(student.account.reload.failed_attempts).to eq(0)
      expect(student.account.locked_at).to be_nil
    end

    context "REDIRECTED_FROM cookie" do
      it "ignores a stale JSON redirect and routes to the judge dashboard" do
        judge = FactoryBot.create(:judge)
        controller.set_cookie(CookieNames::REDIRECTED_FROM, "/judge/scores.json")

        post :create, params: {
          account: {
            email: judge.account.email,
            password: "secret1234"
          }
        }

        expect(response).to redirect_to(judge_dashboard_path)
      end

      it "honours a valid HTML redirect after login" do
        student = FactoryBot.create(:student)
        controller.set_cookie(CookieNames::REDIRECTED_FROM, "/student/teams/1")

        post :create, params: {
          account: {
            email: student.email,
            password: "secret1234"
          }
        }

        expect(response).to redirect_to("/student/teams/1")
      end
    end

    it "sends parent emails for past students registering again" do
      student = FactoryBot.create(
        :onboarded_student,
        parent_guardian_email: "parent2@parent2.com",
        account: FactoryBot.create(
          :account,
          password: "secret1234"
        )
      )

      student.account.update(seasons: [Season.current.year - 1])
      student.parental_consent.update(seasons: [Season.current.year - 1])

      ActionMailer::Base.deliveries.clear

      post :create, params: {
        account: {
          email: student.email,
          password: "secret1234"
        }
      }

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no parent permission email sent"
      expect(mail.to).to eq(["parent2@parent2.com"])
      expect(mail.subject).to include("Your daughter needs permission")

      delete :destroy

      ActionMailer::Base.deliveries.clear

      post :create, params: {account: {email: student.email, password: student.password}}

      expect(ActionMailer::Base.deliveries).to be_empty, "another one was sent"
    end
  end
end
