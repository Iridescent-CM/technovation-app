require "rails_helper"

RSpec.describe ParentalConsentsController do
  describe "POST #create" do
    it "preserves the token on a validation error" do
      student = FactoryGirl.create(:student, :full_profile)
      post :create, params: { parental_consent: { student_profile_consent_token: student.consent_token } }
      expect(assigns[:parental_consent].student_profile_consent_token).to eq(student.consent_token)
    end

    it "emails a copy to the parent" do
      student = FactoryGirl.create(:student, :full_profile)
      post :create, params: { parental_consent: FactoryGirl.attributes_for(:parental_consent, student_profile_consent_token: student.consent_token) }
      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no copy of parental consent was sent"
      expect(mail.to).to eq([student.reload.parent_guardian_email])
      expect(mail.subject).to eq("Technovation — Copy of signed consent form")
    end

    it "notifies the student that they can move on" do
      student = FactoryGirl.create(:student, :full_profile)
      post :create, params: { parental_consent: FactoryGirl.attributes_for(:parental_consent, student_profile_consent_token: student.consent_token) }
      mail = ActionMailer::Base.deliveries[-2]
      expect(mail).to be_present, "no notice to student about parental consent was sent"
      expect(mail.to).to eq([student.email])
      expect(mail.subject).to eq("Technovation next steps: Your parent/guardian signed your permission form!")
    end

    it "allows parents to opt out of the newsletter" do
      student = FactoryGirl.create(:student, :full_profile)

      allow(SubscribeEmailListJob).to receive(:perform_later)

      post :create, params: {
        parental_consent: FactoryGirl.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        ).merge(newsletter_opt_in: "0") }

      expect(SubscribeEmailListJob).not_to have_received(:perform_later)
        .with(student.parent_guardian_email,
              student.parent_guardian_name,
              "PARENT_LIST_ID")
    end

    it "allows parents to opt in to the newsletter" do
      student = FactoryGirl.create(:student, :full_profile)

      allow(SubscribeEmailListJob).to receive(:perform_later)

      post :create, params: {
        parental_consent: FactoryGirl.attributes_for(
          :parental_consent,
          student_profile_consent_token: student.consent_token
        ).merge(newsletter_opt_in: "1") }

      expect(SubscribeEmailListJob).to have_received(:perform_later)
        .at_least(:once)
        .with(student.parent_guardian_email,
              student.parent_guardian_name,
              "PARENT_LIST_ID")
    end
  end

  describe "GET #new" do
    it "assigns the student to the consent" do
      student = FactoryGirl.create(:student, :full_profile)
      get :new, params: { token: student.consent_token }
      expect(assigns[:parental_consent].student_profile_consent_token).to eq(student.consent_token)
    end
  end
end
