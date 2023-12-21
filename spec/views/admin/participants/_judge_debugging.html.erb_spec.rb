require "rails_helper"

RSpec.describe "admin/participants/_judge_debugging.html.erb", type: :view do
  before do
    render partial: "admin/participants/judge_debugging",
      locals: {current_account: current_account, profile: current_profile}
  end

  let(:current_account) do
    instance_double(Account,
      is_admin?: current_account_is_admin)
  end
  let(:current_account_is_admin) { false }

  let(:current_profile) do
    double(JudgeProfile,
      suspended?: judge_suspended,
      consent_signed?: true,
      valid_coordinates?: true,
      survey_completed?: true,
      training_completed?: true,
      mentor_profile: {},
      browser_name: "Mosiac",
      browser_version: "1.0",
      os_name: "Windows 3.1",
      os_version: "3.1")
  end
  let(:judge_suspended) { false }

  context "as an admin" do
    let(:current_account_is_admin) { true }

    it "displays the judge's suspension status" do
      expect(rendered).to have_text("Suspended?")
    end

    context "when the judge is suspended" do
      let(:judge_suspended) { true }

      it "displays a link to enable the judge" do
        expect(rendered).to have_text("Judge suspension")
        expect(rendered).to have_link("Enable this judge")
      end
    end

    context "when the judge is not suspended" do
      let(:judge_suspended) { false }

      it "displays a link to suspend the judge" do
        expect(rendered).to have_text("Judge suspension")
        expect(rendered).to have_link("Suspend this judge")
      end
    end
  end

  context "as a chapter ambassador" do
    let(:current_account_is_admin) { false }

    it "does not display the judge's suspension status" do
      expect(rendered).not_to have_text("Suspended?")
    end

    it "does not display the judge suspension section/controls" do
      expect(rendered).not_to have_text("Judge suspension")
      expect(rendered).not_to have_link("Suspend this judge")
      expect(rendered).not_to have_link("Enable this judge")
    end
  end
end
