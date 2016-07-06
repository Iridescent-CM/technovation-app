require "rails_helper"

class AutoRegisterTest < Capybara::Rails::TestCase
  def test_register_current_season_on_signin
    old_season = Season.create(starts_at: Time.current,
                               year: Time.current.year - 1)
    account = StudentAccount.create(student_attributes)
    account.season_registrations.destroy_all
    SeasonRegistration.register(account, old_season)
    sign_in(account)
    assert account.seasons.include?(Season.find_by(year: Time.current.year))
  end
end
