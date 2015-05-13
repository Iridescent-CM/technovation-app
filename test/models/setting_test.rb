require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    super

    @dates = create_judging_date_settings(Date.new(2015, 2, 1))

    @today = Setting.create!(key: 'todaysDateForTesting', value: @dates[:qf_open] - 1.day)
  end

  test "judging round active set correctly" do
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during quarterfinals
    @today.update_attribute(:value, @dates[:qf_open] + 1.day)
    assert_equal 'quarterfinal', Setting.judgingRound

    # between quarterfinals and semifinals
    @today.update_attribute(:value, @dates[:qf_close] + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during semifinals
    @today.update_attribute(:value, @dates[:sf_open] + 1.day)
    assert_equal 'semifinal', Setting.judgingRound

    # between semifinals and finals
    @today.update_attribute(:value, @dates[:sf_close] + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound
  end

  test "next judging round should be set correctly" do
    assert_equal ['quarterfinal', @dates[:qf_open]], Setting.nextJudgingRound

    # during quarterfinals
    @today.update_attribute(:value, @dates[:qf_open] + 1.day)
    assert_equal ['quarterfinal', @dates[:qf_open]], Setting.nextJudgingRound

    # between quarterfinals and semifinals
    @today.update_attribute(:value, @dates[:qf_close] + 1.day)
    assert_equal ['semifinal', @dates[:sf_open]], Setting.nextJudgingRound

    # during semifinals
    @today.update_attribute(:value, @dates[:sf_open] + 1.day)
    assert_equal ['semifinal', @dates[:sf_open]], Setting.nextJudgingRound

    # between semifinals and finals
    @today.update_attribute(:value, @dates[:sf_close] + 1.day)
    assert_equal ['final', @dates[:f_open]], Setting.nextJudgingRound
  end
end
