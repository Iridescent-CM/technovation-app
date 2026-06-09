require "rails_helper"

RSpec.describe ExportJob do
  describe "#perform" do
    it "deletes blanks from array params" do
      chapter_ambassador = FactoryBot.create(
        :ambassador,
        city: "Salvador",
        state_province: "Bahia",
        country: "BR"
      )

      allow(AccountsGrid).to receive(:new).and_return(double(:grid).as_null_object)
      allow(Job).to receive(:find_by).and_return(double(:job).as_null_object)
      allow(ActionCable).to receive(:server).and_return(double(:server).as_null_object)
      allow(chapter_ambassador).to receive(:exports).and_return(double(:exports).as_null_object)

      ExportJob.perform_now(
        chapter_ambassador.id,
        "ChapterAmbassadorProfile",
        "AccountsGrid",
        {
          admin: false,
          allow_state_search: true,
          country: ["", "BR"],
          state_province: ["", "BH"],
          city: ["", "Salvador"],
          column_names: ["", "city", "state_province"],
          scope_names: ["", "chapter_ambassador"],
          season: ["", "2018"]
        },
        "Ambassador::ParticipantsController",
        "->(scope, user, params) { scope.in_region(user) }",
        "filename",
        "csv"
      )

      expected_params = {
        admin: false,
        allow_state_search: true,
        country: ["BR"],
        state_province: ["BH"],
        city: ["Salvador"],
        column_names: ["city", "state_province"],
        scope_names: ["chapter_ambassador"],
        season: ["2018"]
      }

      expect(AccountsGrid).to have_received(:new).with(expected_params)
    end

    it "marks the job as failed when export raises an error" do
      admin = FactoryBot.create(:admin)

      allow(AccountsGrid).to receive(:new).and_raise(StandardError, "export failed")
      allow(ActionCable).to receive(:server).and_return(double(:server).as_null_object)

      expect {
        ExportJob.perform_later(
          admin.id,
          "AdminProfile",
          "AccountsGrid",
          {},
          "Admin::ParticipantsController",
          "->(scope, user, params) { scope }",
          "filename",
          "csv"
        )
      }.to raise_error(StandardError, "export failed")

      job = Job.find_by!(owner: admin)
      expect(job.status).to eq("failed")
    end
  end
end
