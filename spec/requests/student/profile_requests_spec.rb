require "rails_helper"

RSpec.describe "Student Profile Requests", type: :request do
  let(:student_account) { FactoryBot.create(:account, email: student_email_address) }
  let(:student_email_address) { "harry@example.com"  }
  let(:student_profile) {
    FactoryBot.create(:student_profile, :geocoded,
      account: student_account,
      parent_guardian_email: parent_guardian_email_address)
  }
  let(:parent_guardian_email_address) { "lily@example.com" }

  before do
    sign_in(student_profile)
  end

  describe "updating a student profile" do
    before do
      patch student_profile_path, params: params, headers: headers
    end

    let(:headers) { { "ACCEPT" => "text/html" } }
    let(:params) do
      { student_profile: {
        account_attributes: { id: student_account.id }
      } }
    end

    context "when the :setting_location param is present, and country and latitude are both blank" do
      let(:params) do
        {
          setting_location: { bing: "bong" },
          student_profile: {
            account_attributes: { id: student_account.id,
                                  country: "",
                                  latitude: "" }
          }
        }
      end

      it "renders the location_details/show template" do
        expect(response).to render_template("location_details/show")
      end
    end

    context "when updating is successful" do
      before do
        allow(ProfileUpdating).to receive(:execute).and_return(true)

        patch student_profile_path, params: params, headers: headers
      end

      context "when it's an HTML request" do
        let(:headers) { { "ACCEPT" => "text/html" } }

        it "redirects to the student profile page" do
          expect(response).to redirect_to("/student/profile")
        end
      end

      context "when it's a JSON request" do
        let(:headers) { {  "ACCEPT" => "application/json" } }

        it "returns a success message in JSON format" do
          expect(response.body).to include("You updated your account!")
          expect(response.content_type).to eq("application/json")
        end
      end
    end

    context "when a student is trying to change their email address without providing their existing password" do
      let(:params) do
        {
          student_profile: {
            account_attributes: { id: student_account.id,
                                  email: "harry2.0@example.com" }
          }
        }
      end

      it "renders the edit email address template" do
        expect(response).to render_template("email_addresses/edit")
      end
    end

    context "when a student is trying to set a new password without providing their existing password" do
      let(:params) do
        {
          student_profile: {
            account_attributes: { id: student_account.id,
                                  password: "mugglesftw" }
          }
        }
      end

      it "renders the edit password template" do
        expect(response).to render_template("passwords/edit")
      end
    end

    context "when a student is changing their email address to be the same as their parent's email address" do
      let(:params) do
        {
          student_profile: {
            account_attributes: { id: student_account.id,
                                  email: parent_guardian_email_address,
                                  existing_password: "secret1234" }
          }
        }
      end

      it "renders the edit email address template" do
        expect(response).to render_template("email_addresses/edit")
      end
    end

    context "when there is any other validation error" do
      let(:params) do
        {
          student_profile: {
            account_attributes: { id: student_account.id,
                                  first_name: "",
                                  last_name: "" }
          }
        }
      end

      it "renders the edit profile template" do
        expect(response).to render_template("edit")
      end
    end
  end
end
