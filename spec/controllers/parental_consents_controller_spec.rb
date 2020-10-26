require "rails_helper"

RSpec.describe ParentalConsentsController do
  describe "PATCH #update" do
    it "preserves the token on a validation error" do
      student = FactoryBot.create(:onboarding_student)

      patch :update, params: { id: student.parental_consent.id,
        parental_consent: {
          student_profile_consent_token: student.consent_token
        }
      }

      expect(assigns[:parental_consent].student_profile_consent_token).to eq(
        student.consent_token
      )
    end

    it "emails a copy to the parent" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty2@parent.com",
        parent_guardian_name: "parenty2"
      )

      patch :update, params: { id: student.parental_consent.id,
        parental_consent: FactoryBot.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        )
      }

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no copy of parental consent was sent"
      expect(mail.to).to eq(["parenty2@parent.com"])
      expect(mail.subject).to eq("Technovation — Copy of signed consent form")
    end

    it "notifies the student that they can move on" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty3@parent.com",
        parent_guardian_name: "parenty3"
      )

      patch :update, params: { id: student.parental_consent.id,
        parental_consent: FactoryBot.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        )
      }

      mail = ActionMailer::Base.deliveries[-2]
      expect(mail).to be_present,
        "no notice to student about parental consent was sent"

      expect(mail.to).to eq([student.email])
      expect(mail.subject).to eq(
        "Technovation next steps: Your parent/guardian signed your permission form!"
      )
    end

    it "allows parents to opt out of the newsletter" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty4@parent.com",
        parent_guardian_name: "parenty4"
      )

      allow(SubscribeParentToEmailListJob).to receive(:perform_later)

      patch :update, params: { id: student.parental_consent.id,
        parental_consent: FactoryBot.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        ).merge(newsletter_opt_in: "0") }

      expect(SubscribeParentToEmailListJob).not_to have_received(:perform_later)
        .with(any_args)
    end

    it "allows parents to opt in to the newsletter" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty@parent.com",
        parent_guardian_name: "parenty"
      )

      allow(SubscribeParentToEmailListJob).to receive(:perform_later)

      patch :update, params: { id: student.parental_consent.id,
        parental_consent: FactoryBot.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        ).merge(newsletter_opt_in: "1") }

      expect(SubscribeParentToEmailListJob).to have_received(:perform_later)
        .at_least(:once)
        .with(student_profile_id: student.id)
    end

    it "shows the existing parental consent if a repeat visit is made" do
      student = FactoryBot.create(:onboarded_student)

      expect {
        patch :update, params: { id: student.parental_consent.id,
          parental_consent: FactoryBot.attributes_for(
            :parental_consent,
            student_profile_consent_token: student.consent_token
          )
        }
      }.not_to change {
        ParentalConsent.nonvoid.count
      }

      expect(response).to redirect_to(
        parental_consent_path(student.parental_consent)
      )
    end
  end

  describe "GET #edit" do
    it "assigns the student to the consent" do
      student = FactoryBot.create(:onboarding_student)

      get :edit, params: { token: student.consent_token }

      expect(assigns[:parental_consent].student_profile_consent_token).to eq(
        student.consent_token
      )
    end

    it "shows the existing parental consent if a repeat visit is made" do
      student = FactoryBot.create(:onboarded_student)

      get :edit, params: { token: student.consent_token }

      expect(response).to redirect_to(
        parental_consent_path(student.parental_consent)
      )
    end
  end
end
