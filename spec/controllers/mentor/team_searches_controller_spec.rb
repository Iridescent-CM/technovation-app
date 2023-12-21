require "rails_helper"

RSpec.describe Mentor::TeamSearchesController do
  it "sanitizes bad division selection input" do
    sign_in(FactoryBot.create(:mentor, :onboarded))

    get :new, params: {division_enums: {"0" => "0"}}

    expect(controller.params[:division_enums]).to eq(["0"])
  end
end
