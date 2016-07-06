require "rails_helper"

RSpec.describe Account do
  before { Season.create_current }

  subject(:account) { FactoryGirl.create(:account) }

  it "registers itself to the current season on create" do
    expect(account.seasons).to include(Season.current)
  end

  it "sets an auth token" do
    expect(account.auth_token).not_to be_blank
  end
end
