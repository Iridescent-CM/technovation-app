require "spec_helper"
require "./spec/support/setting_helper"
require "./app/policies/team_policy"

RSpec.describe "Policy to edit a team" do
  describe "#edit?" do
    include SettingHelper

    it "is true for memebers when submissions are open" do
      stub_submissions_to_open_on(Date.today)
      user = double(:user)
      team = double(:team, members: [user])

      policy = TeamPolicy.new(user, team)

      expect(policy.edit?).to be true
    end

    it "is false for members when submissions are closed" do
      stub_submissions_to_open_on(Date.today - 1)
      user = double(:user)
      team = double(:team, members: [user])

      policy = TeamPolicy.new(user, team)

      expect(policy.edit?).to be false
    end

    it "is false for non members" do
      stub_submissions_to_open_on(Date.today)
      user = double(:user)
      team = double(:team, members: [])

      policy = TeamPolicy.new(user, team)

      expect(policy.edit?).to be false
    end
  end
end
