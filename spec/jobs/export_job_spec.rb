require "rails_helper"

RSpec.describe ExportJob do
  describe "#perform" do
    it "deletes blanks from array params" do
      ra = FactoryBot.create(
        :ambassador,
        city: "Salvador",
        state_province: "BA",
        country: "BR"
      )

      allow(AccountsGrid).to receive(:new).and_return(double(:grid).as_null_object)
      allow(Job).to receive(:find_by).and_return(double(:job).as_null_object)
      allow(ActionCable).to receive(:server).and_return(double(:server).as_null_object)
      allow(ra).to receive(:exports).and_return(double(:exports).as_null_object)

      ExportJob.perform_now(
        ra.id,
        "RegionalAmbassadorProfile",
        "AccountsGrid",
        {
          admin: false,
          allow_state_search: true,
          country: ["", "BR"],
          state_province: ["", "BH"],
          city: ["", "Salvador"],
          column_names: ["", "city", "state_province"],
          scope_names: ["", "regional_ambassador"],
          season: ["", "2018"],
        },
        "RegionalAmbassador::ParticipantsController",
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
        scope_names: ["regional_ambassador"],
        season: ["2018"],
      }

      expect(AccountsGrid).to have_received(:new).with(expected_params)
    end
  end
end
