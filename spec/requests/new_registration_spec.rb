require "rails_helper"

RSpec.describe "New registration", type: :request do
  let(:params) do
    {
      profileType: profile_type,
      new_registration: {
        firstName: "Barbara",
        lastName: "Barburry",
        meetsMinimumAgeRequirement: true,
        dateOfBirth: date_of_birth,
        gender: "Non-binary",
        email: "personxyz@example.com",
        password: "12345678",
        dataTermsAgreedTo: true,
        studentParentGuardianName: "Mursmiss Parentente",
        studentParentGuardianEmail: "mrmsparents@example.com",
        studentSchoolName: "Top School 1",
        mentorSchoolCompanyName: "Wonderful Inc",
        mentorJobTitle: "Widgets ",
        judgeSchoolCompanyName: "Court House",
        judgeJobTitle: "Main Judge"
      }
    }
  end
  let(:profile_type) { "student" }
  let(:date_of_birth) { (Division.cutoff_date - 15.years) }

  describe "Account#parent_registered?" do
    subject(:registered_account) do
      post new_registration_path, params: params

      Account.find_by!(email: params[:new_registration][:email])
    end

    before do
      allow(SignIn).to receive(:call)
      SeasonToggles.registration_open!
    end

    context "when a parent is registering (a beginner student)" do
      let(:profile_type) { "parent" }
      let(:date_of_birth) { (Division.cutoff_date - 8.years) }

      it "sets the parent_registered? flag to true" do
        expect(registered_account.parent_registered?).to eq(true)
      end
    end

    context "when a student is registering" do
      let(:profile_type) { "student" }
      let(:date_of_birth) { (Division.cutoff_date - 13.years) }

      it "sets the parent_registered? flag to false" do
        expect(registered_account.parent_registered?).to eq(false)
      end
    end

    context "when a mentor is registering" do
      let(:profile_type) { "mentor" }
      let(:date_of_birth) { nil }

      before do
        mentor_type = FactoryBot.create(:mentor_type)
        params[:new_registration][:mentorTypes] = [mentor_type.id]
      end

      it "sets the parent_registered? flag to false" do
        expect(registered_account.parent_registered?).to eq(false)
      end
    end

    context "when a judge is registering" do
      let(:profile_type) { "judge" }
      let(:date_of_birth) { nil }

      before do
        judge_type = FactoryBot.create(:judge_type)
        params[:new_registration][:judgeTypes] = [judge_type.id]
      end

      it "sets the parent_registered? flag to false" do
        expect(registered_account.parent_registered?).to eq(false)
      end
    end
  end
end
