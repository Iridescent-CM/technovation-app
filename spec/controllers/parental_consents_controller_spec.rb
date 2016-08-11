require "rails_helper"

RSpec.describe ParentalConsentsController do
  describe "POST #create" do
    it "preserves the token on a validation error" do
      student = FactoryGirl.create(:student)
      post :create, parental_consent: { student_consent_token: student.consent_token }
      expect(assigns[:parental_consent].student_consent_token).to eq(student.consent_token)
    end
  end

  describe "GET #new" do
    it "assigns the student to the consent" do
      student = FactoryGirl.create(:student)
      get :new, token: student.consent_token
      expect(assigns[:parental_consent].student_consent_token).to eq(student.consent_token)
    end
  end
end
