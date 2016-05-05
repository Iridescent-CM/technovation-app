require "spec_helper"
require "./app/policies/team_policy"
require "ostruct"

RSpec.describe "Policy for creating a team" do
  describe "#create?" do
    def stub_submissions_to_open_on(date)
      # Stub the submissions open/close dates
      # Yes, this knowledge needs to be improved
      setting_record = OpenStruct.new(value: date.to_s)
      setting = double(:setting, :find_by! => setting_record)
      allow(Submissions).to receive(:setting) { setting }
    end

    it "is true for non-students without a team when submissions are open" do
      stub_submissions_to_open_on(Date.today)

      user = double(:user, :student? => false,
                           :has_team_for_season? => false)
      team = double(:team)

      policy = TeamPolicy.new(user, team)

      expect(policy.create?).to be true
    end

    it "is false for non-students when submissions are closed" do
      stub_submissions_to_open_on(Date.today - 1)

      user = double(:user, :student? => false,
                           :has_team_for_season? => false)
      team = double(:team)

      policy = TeamPolicy.new(user, team)

      expect(policy.create?).to be false
    end

    it "is false students who have a team" do
      stub_submissions_to_open_on(Date.today)

      user = double(:user, :student? => true,
                           :has_team_for_season? => true)
      team = double(:team)

      policy = TeamPolicy.new(user, team)

      expect(policy.create?).to be false
    end

    it "is true students who don't have a team" do
      stub_submissions_to_open_on(Date.today)

      user = double(:user, :student? => true,
                           :has_team_for_season? => false)
      team = double(:team)

      policy = TeamPolicy.new(user, team)

      expect(policy.create?).to be true
    end
  end
end
