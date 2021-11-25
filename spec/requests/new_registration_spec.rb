require "rails_helper"

RSpec.describe "New registration", type: :request do
  let(:params) do
    {
      profileType: profile_type,
      new_registration: {
        firstName: "Barbara",
        lastName: "Barburry",
        dateOfBirth: date_of_birth,
        gender: "Non-binary",
        email: "personxyz@example.com",
        password: "12345678",
        studentParentGuardianName: "Mursmiss Parentente",
        studentParentGuardianEmail: "mrmsparents@example.com",
        studentSchoolName: "Top School 1",
        mentorType: "Educator",
        mentorSchoolCompanyName: "Wonderful Inc",
        mentorJobTitle: "Widgets "
      }
    }
  end
  let(:profile_type) { "student" }
  let(:date_of_birth) { (Division.cutoff_date - 15.years) }

  describe "Account#parent_registered?" do
    before do
      allow(SignIn).to receive(:call)

      post new_registration_path, params: params
    end

    context "when a parent is registering (a beginner student)" do
      let(:profile_type) { "parent" }
      let(:date_of_birth) { (Division.cutoff_date - 8.years) }

      it "sets the parent_registered? flag to true" do
        expect(Account.last.parent_registered?).to eq(true)
      end
    end

    context "when a student is registering" do
      let(:profile_type) { "student" }
      let(:date_of_birth) { (Division.cutoff_date - 13.years) }

      it "sets the parent_registered? flag to false" do
        expect(Account.last.parent_registered?).to eq(false)
      end
    end

    context "when a mentor is registering" do
      let(:profile_type) { "mentor" }
      let(:date_of_birth) { (Division.cutoff_date - 26.years) }

      it "sets the parent_registered? flag to false" do
        expect(Account.last.parent_registered?).to eq(false)
      end
    end
  end
end
