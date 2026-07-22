require "rails_helper"

RSpec.describe "admin/participants/_certificates.en.html.erb", type: :view do
  let(:account) { FactoryBot.create(:judge).account }
  let(:certificates) { [] }
  let(:needed_certificates) { [] }

  before do
    assign(:certificates, certificates)
    assign(:needed_certificates, needed_certificates)
    render partial: "admin/participants/certificates", locals: {account: account}
  end

  it "shows manual letter award controls for judges" do
    expect(rendered).to have_content("Manually award letters of recognition")
    expect(rendered).to have_content("Judge letter")
    expect(rendered).to have_select("certificate_type", with_options: ["Bronze Judge", "Silver Judge", "Gold Judge"])
  end

  context "when the account is a mentor" do
    let(:account) { FactoryBot.create(:mentor).account }

    it "shows a mentor letter award form" do
      expect(rendered).to have_content("Mentor letter")
      expect(rendered).to have_field("certificate_type", type: "hidden", with: "mentor_letter")
    end
  end

  context "when the account is an ambassador" do
    let(:account) { FactoryBot.create(:chapter_ambassador).account }

    it "shows an ambassador letter award form" do
      expect(rendered).to have_content("Ambassador letter")
      expect(rendered).to have_field("certificate_type", type: "hidden", with: "ambassador_letter")
    end
  end
end
