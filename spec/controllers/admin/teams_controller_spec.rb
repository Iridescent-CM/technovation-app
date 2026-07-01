require "rails_helper"

RSpec.describe Admin::TeamsController do
  describe "POST #set_semifinalists" do
    let(:super_admin) { FactoryBot.create(:super_admin) }
    let(:admin) { FactoryBot.create(:admin) }
    let(:sub1) { FactoryBot.create(:submission, :complete) }

    def csv_upload(contents)
      file = Tempfile.new(["semifinalists", ".csv"])
      file.write(contents)
      file.rewind

      Rack::Test::UploadedFile.new(
        file.path,
        "text/csv",
        original_filename: "semifinalists.csv"
      )
    end

    it "updates submissions for super admins" do
      sign_in(super_admin)

      post :set_semifinalists, params: {
        csv_file: csv_upload("Submission ID\n#{sub1.id}\n")
      }

      expect(sub1.reload).to be_semifinalist
      expect(response).to redirect_to(admin_teams_path)
      expect(flash[:success]).to include("Updated 1 submissions")
    end

    it "updates submissions for admins" do
      sign_in(admin)

      post :set_semifinalists, params: {
        csv_file: csv_upload("Submission ID\n#{sub1.id}\n")
      }

      expect(sub1.reload).to be_semifinalist
      expect(response).to redirect_to(admin_teams_path)
      expect(flash[:success]).to include("Updated 1 submissions")
    end

    it "shows an error when the CSV is missing the submission id column" do
      sign_in(super_admin)

      post :set_semifinalists, params: {
        csv_file: csv_upload("Team ID\n123\n")
      }

      expect(response).to redirect_to(admin_teams_path)
      expect(flash[:error]).to include("Submission ID")
    end
  end
end
