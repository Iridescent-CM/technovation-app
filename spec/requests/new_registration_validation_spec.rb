require "rails_helper"

RSpec.describe "New registration validation", type: :request do
  let(:base_params) do
    {
      profileType: profile_type,
      new_registration: {
        firstName: "Barbara",
        lastName: "Barburry",
        meetsMinimumAgeRequirement: true,
        dateOfBirth: date_of_birth,
        gender: "Non-binary",
        email: "personxyz@example.com",
        password: password,
        dataTermsAgreedTo: data_terms_agreed_to,
        studentParentGuardianName: "Mursmiss Parentente",
        studentParentGuardianEmail: "mrmsparents@example.com",
        studentSchoolName: "Top School 1"
      }
    }
  end
  let(:profile_type) { "student" }
  let(:date_of_birth) { (Division.cutoff_date - 15.years).to_s }
  let(:password) { PasswordHelpers::VALID_PASSWORD }
  let(:data_terms_agreed_to) { true }

  before do
    allow(SignIn).to receive(:call)
    SeasonToggles.registration_open!
  end

  describe "POST /new-registration" do
    subject(:register) { post new_registration_path, params: base_params, as: :json }

    context "when registration is closed" do
      before { SeasonToggles.registration_closed! }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"]).to include(
          "Registration is not open for this profile type"
        )
      end

      context "with a valid invite for the profile type" do
        let(:invite) do
          UserInvitation.create!(
            profile_type: "student",
            email: "invited.student@example.com",
            register_at_any_time: true
          )
        end

        before do
          base_params[:inviteCode] = invite.admin_permission_token
          base_params[:new_registration][:email] = "invited.student@example.com"
        end

        it "allows registration" do
          expect { register }.to change(Account, :count).by(1)
          expect(response).not_to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "with an invalid profile type" do
      let(:profile_type) { "hacker" }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"]).to include("Invalid profile type")
      end
    end

    context "with an out-of-range student age" do
      let(:date_of_birth) { (Division.cutoff_date - 5.years).to_s }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"].join).to include(
          "13 and 18 years old"
        )
      end
    end

    context "with a password shorter than 8 characters" do
      let(:password) { "short" }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"].join).to match(/password/i)
      end
    end

    context "with a password that does not meet complexity requirements" do
      let(:password) { "12345678" }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"].join).to match(/password/i)
      end
    end

    context "without agreeing to terms" do
      let(:data_terms_agreed_to) { false }

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"].join).to match(/terms/i)
      end
    end

    context "when registering as a judge without judge types" do
      let(:profile_type) { "judge" }
      let(:date_of_birth) { nil }

      before do
        base_params[:new_registration].merge!(
          judgeSchoolCompanyName: "Court House",
          judgeJobTitle: "Main Judge"
        )
        base_params[:new_registration].delete(:studentParentGuardianName)
        base_params[:new_registration].delete(:studentParentGuardianEmail)
        base_params[:new_registration].delete(:studentSchoolName)
      end

      it "returns unprocessable entity" do
        register

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["full_error_messages"].join).to match(/judge type/i)
      end
    end
  end
end
