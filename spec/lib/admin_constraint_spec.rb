# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminConstraint do
  def request_for(auth_token)
    signed_jar = {CookieNames::AUTH_TOKEN => auth_token}
    cookie_jar = instance_double(ActionDispatch::Cookies::CookieJar, signed: signed_jar)
    instance_double(ActionDispatch::Request, cookie_jar: cookie_jar)
  end

  it "matches an active admin auth token" do
    admin = FactoryBot.create(:admin)

    expect(described_class.new.matches?(request_for(admin.account.auth_token))).to be(true)
  end

  it "does not match a deactivated admin" do
    admin = FactoryBot.create(:admin)
    admin.account.update!(deactivated_at: Time.current)

    expect(described_class.new.matches?(request_for(admin.account.auth_token))).to be(false)
  end

  it "does not match a non-admin account" do
    student = FactoryBot.create(:student)

    expect(described_class.new.matches?(request_for(student.account.auth_token))).to be(false)
  end

  it "does not match a blank auth token" do
    expect(described_class.new.matches?(request_for(nil))).to be(false)
  end
end
