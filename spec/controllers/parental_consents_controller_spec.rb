require "rails_helper"

RSpec.describe ParentalConsentsController do
  describe "PATCH #update" do
    it "preserves the token on a validation error" do
      student = FactoryBot.create(:onboarding_student)

      patch :update, params: {id: student.parental_consent.id,
                              parental_consent: {
                                student_profile_consent_token: student.consent_token
                              }}

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

      patch :update, params: {id: student.parental_consent.id,
                              parental_consent: FactoryBot.attributes_for(
                                :parental_consent,
                                student_profile_consent_token: student.consent_token
                              )}

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no copy of parental consent was sent"
      expect(mail.to).to eq(["parenty2@parent.com"])
      expect(mail.subject).to eq("Technovation — Copy of signed participation consent form")
    end

    it "notifies the student that they can move on" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty3@parent.com",
        parent_guardian_name: "parenty3"
      )

      patch :update, params: {id: student.parental_consent.id,
                              parental_consent: FactoryBot.attributes_for(
                                :parental_consent,
                                student_profile_consent_token: student.consent_token
                              )}

      mail = ActionMailer::Base.deliveries[-2]
      expect(mail).to be_present,
        "no notice to student about parental consent was sent"

      expect(mail.to).to eq([student.email])
      expect(mail.subject).to eq(
        "Technovation next steps: Your parent/guardian signed your permission form!"
      )
    end

    it "allows parents to opt out of the newsletter (sent via our CRM)" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty4@parent.com",
        parent_guardian_name: "parenty4"
      )

      patch :update, params: {id: student.parental_consent.id,
                              parental_consent: FactoryBot.attributes_for(
                                :parental_consent,
                                student_profile_consent_token: student.consent_token
                              ).merge(newsletter_opt_in: "0")}

      expect(CRM::UpsertContactInfoJob).not_to receive(:perform_later)
    end

    it "allows parents to opt in to the newsletter (sent via our CRM)" do
      student = FactoryBot.create(:onboarding_student)
      student.update_columns(
        parent_guardian_email: "parenty@parent.com",
        parent_guardian_name: "parenty"
      )

      allow(CRM::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {id: student.parental_consent.id,
                              parental_consent: FactoryBot.attributes_for(
                                :parental_consent,
                                student_profile_consent_token: student.consent_token
                              ).merge(newsletter_opt_in: "1")}

      expect(CRM::UpsertContactInfoJob).to have_received(:perform_later)
        .at_least(:once)
        .with(
          account_id: student.account.id,
          profile_type: "student"
        )
    end

    it "redirects to the media consent form" do
      student = FactoryBot.create(:onboarding_student)

      patch :update, params: {
        id: student.parental_consent.id,
        parental_consent: FactoryBot.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        )
      }

      expect(response).to redirect_to(
        edit_media_consent_path(token: student.consent_token)
      )
    end

    it "shows the existing parental consent if a repeat visit is made" do
      student = FactoryBot.create(:onboarded_student)

      expect {
        patch :update, params: {id: student.parental_consent.id,
                                parental_consent: FactoryBot.attributes_for(
                                  :parental_consent,
                                  student_profile_consent_token: student.consent_token
                                )}
      }.not_to change {
        ParentalConsent.nonvoid.count
      }

      expect(response).to redirect_to(
        parental_consent_path(student.parental_consent)
      )
    end
  end

  describe "GET #edit" do
    let(:student) { FactoryBot.create(:onboarding_student) }

    before do
      get :edit, params: {token: student.consent_token}
    end

    it "assigns @parental_consent" do
      expect(assigns(:parental_consent)).to eq(student.parental_consent)
    end

    it "assigns @parental_consent.student_profile_consent_token" do
      expect(assigns[:parental_consent].student_profile_consent_token).to eq(
        student.consent_token
      )
    end

    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
  end
end
