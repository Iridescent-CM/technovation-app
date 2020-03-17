require "rails_helper"

RSpec.describe "admin/participants/judge_debugging", type: :view do
  before do
    render partial: "admin/participants/judge_debugging",
      locals: { current_account: current_account, profile: current_profile }
  end

  let(:current_account) {
    instance_double(
      Account,
      is_admin?: current_account_admin
    )
  }

  let(:current_profile) {
    FactoryBot.create(:judge).judge_profile
  }

  context "as an admin" do
    let(:current_account_admin) { true }
    
    it "shows judge suspended status" do
      expect(rendered).to have_text("Suspended?")
    end

    it "shows judge suspension section" do
      expect(rendered).to have_text("Judge suspension")
      expect(rendered).to have_link("Suspend this judge")
    end
  end

  context "as an RA" do
    let(:current_account_admin) { false }

    it "does not show judge suspended status" do
      expect(rendered).not_to have_text("Suspended?")
    end

    it "does not show judge suspension section" do
      expect(rendered).not_to have_text("Judge suspension")
      expect(rendered).not_to have_link("Suspend this judge")
    end
  end
end