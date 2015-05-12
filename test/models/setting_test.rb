require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test "judging round active set correctly" do
    @qf_open = Date.new(2015, 1, 1)
    @qf_close = Date.new(2015, 1, 10)
    @sf_open = Date.new(2015, 1, 13)
    @sf_close = Date.new(2015, 1, 18)

    Setting.create!(key:'quarterfinalJudgingOpen', value: @qf_open)
    Setting.create!(key:'quarterfinalJudgingClose', value: @qf_close)
    Setting.create!(key:'semifinalJudgingOpen', value: @sf_open)
    Setting.create!(key:'semifinalJudgingClose', value: @sf_close)
    Setting.create!(key:'finalJudgingOpen', value: Date.new(2020, 1, 1)) # not used
    Setting.create!(key:'finalJudgingClose', value: Date.new(2020, 1, 1)) # not used

    today = Setting.create!(key: 'todaysDateForTesting', value: @qf_open - 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during quarterfinals
    today.update_attribute(:value, @qf_open + 1.day)
    assert_equal 'quarterfinal', Setting.judgingRound

    # between quarterfinals and semifinals
    today.update_attribute(:value, @qf_close + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during semifinals
    today.update_attribute(:value, @sf_open + 1.day)
    assert_equal 'semifinal', Setting.judgingRound

    # between semifinals and finals
    today.update_attribute(:value, @sf_close + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound
  end
end
