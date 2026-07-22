require "rails_helper"

RSpec.describe CertificateRecipient do
  it "considers same state equal" do
    account = FactoryBot.create(:mentor).account
    team = FactoryBot.create(:team)

    a = CertificateRecipient.new(:mentor, account, team: team, season: 2018)
    b = CertificateRecipient.new(:mentor, account, team: team, season: 2018)

    expect(a).to eq(b)
    expect(a).not_to eql(b)
  end

  it "creates from state" do
    account = FactoryBot.create(:mentor).account
    team = FactoryBot.create(:team)

    a = CertificateRecipient.new(:mentor, account, team: team, season: 2018)
    b = CertificateRecipient.from_state(a.state)

    expect(a).to eq(b)
  end

  it "describes letter types as letters of recognition" do
    account = FactoryBot.create(:judge).account

    recipient = CertificateRecipient.new(:bronze_judge_letter, account)

    expect(recipient.description).to eq("Letter of Recognition (Bronze Judge)")
  end
end
