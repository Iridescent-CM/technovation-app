require "rails_helper"

describe JudgeDashboardRedirector do
  let(:judge_dashboard_redirector) {
    JudgeDashboardRedirector.new(
      account: account,
      season_toggles: season_toggles
    )
  }

  let(:account) {
    instance_double(Account,
      can_switch_to_judge?: account_can_switch_to_judge,
      judge_profile: account_judge_profile)
  }
  let(:account_can_switch_to_judge) { false }
  let(:account_judge_profile) { instance_double(JudgeProfile) }
  let(:season_toggles) {
    double("season toggles",
      judging_enabled_or_between?: season_toggles_judging_enabled_or_between)
  }
  let(:season_toggles_judging_enabled_or_between) { false }

  describe "#enabled?" do
    context "when the account is able to become a judge" do
      let(:account_can_switch_to_judge) { true }

      context "when judging is turned on" do
        let(:season_toggles_judging_enabled_or_between) { true }

        context "when the account has a judge profile" do
          let(:account_judge_profile) { instance_double(JudgeProfile) }

          it "returns true" do
            expect(judge_dashboard_redirector.enabled?).to eq(true)
          end
        end
      end
    end

    context "when the account isn't able to become a judge" do
      let(:account_can_switch_to_judge) { false }

      it "returns false" do
        expect(judge_dashboard_redirector.enabled?).to eq(false)
      end
    end

    context "when judging is turned off" do
      let(:season_toggles_judging_enabled_or_between) { false }

      it "returns false" do
        expect(judge_dashboard_redirector.enabled?).to eq(false)
      end
    end

    context "when the account does not have a judge profile" do
      let(:account_judge_profile) { false }

      it "returns false" do
        expect(judge_dashboard_redirector.enabled?).to eq(false)
      end
    end
  end
end
