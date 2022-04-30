class JudgeDashboardRedirector
  def initialize(account:, season_toggles: SeasonToggles)
    @account = account
    @season_toggles = season_toggles
  end

  def enabled?
    account.can_switch_to_judge? &&
      season_toggles.judging_enabled_or_between? &&
      account.judge_profile.present?
  end

  private

  attr_reader :account, :season_toggles
end
