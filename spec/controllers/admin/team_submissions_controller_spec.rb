require "rails_helper"

RSpec.describe Admin::TeamSubmissionsController do
  describe "GET #index :json" do
    it "exports csv okay" do
      sign_in(:admin)

      expect {
        get :index, format: :json, params: {submissions_grid: {}}
      }.to change { Export.count }.by(1)
    end
  end

  describe "PATCH #return_to_judging_pool" do
    let(:team_submission) { FactoryBot.create(:submission, removed_from_judging_pool: true) }
    let(:admin) { FactoryBot.create(:admin) }

    it "sets removed from judging pool to false" do
      sign_in(admin)

      patch :return_to_judging_pool, params: {team_submission_id: team_submission.id}

      team_submission.reload
      expect(team_submission.removed_from_judging_pool).to be false
      expect(team_submission.returned_to_judging_pool_by_account_id).to eq(admin.account.id)
    end
  end

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
      expect(response).to redirect_to(admin_team_submissions_path)
      expect(flash[:success]).to include("Updated 1 submissions")
    end

    it "updates submissions for admins" do
      sign_in(admin)

      post :set_semifinalists, params: {
        csv_file: csv_upload("Submission ID\n#{sub1.id}\n")
      }

      expect(sub1.reload).to be_semifinalist
      expect(response).to redirect_to(admin_team_submissions_path)
      expect(flash[:success]).to include("Updated 1 submissions")
    end

    it "shows an error when the CSV is missing the submission id column" do
      sign_in(super_admin)

      post :set_semifinalists, params: {
        csv_file: csv_upload("Team ID\n123\n")
      }

      expect(response).to redirect_to(admin_team_submissions_path)
      expect(flash[:error]).to include("Submission ID")
    end
  end
end
