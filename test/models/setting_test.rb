require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    super

    @qf_open = Date.new(2015, 1, 1)
    @qf_close = Date.new(2015, 1, 10)
    @sf_open = Date.new(2015, 1, 13)
    @sf_close = Date.new(2015, 1, 18)
    @f_open = Date.new(2015, 1, 23)
    @f_close = Date.new(2015, 1, 28)

    Setting.create!(key:'quarterfinalJudgingOpen', value: @qf_open)
    Setting.create!(key:'quarterfinalJudgingClose', value: @qf_close)
    Setting.create!(key:'semifinalJudgingOpen', value: @sf_open)
    Setting.create!(key:'semifinalJudgingClose', value: @sf_close)
    Setting.create!(key:'finalJudgingOpen', value: @f_open)
    Setting.create!(key:'finalJudgingClose', value: @f_close)

    @today = Setting.create!(key: 'todaysDateForTesting', value: @qf_open - 1.day)
  end

  test "judging round active set correctly" do
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during quarterfinals
    @today.update_attribute(:value, @qf_open + 1.day)
    assert_equal 'quarterfinal', Setting.judgingRound

    # between quarterfinals and semifinals
    @today.update_attribute(:value, @qf_close + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound

    # during semifinals
    @today.update_attribute(:value, @sf_open + 1.day)
    assert_equal 'semifinal', Setting.judgingRound

    # between semifinals and finals
    @today.update_attribute(:value, @sf_close + 1.day)
    assert_equal Setting::NO_ROUND, Setting.judgingRound
  end

  test "next judging round should be set correctly" do
    assert_equal ['quarterfinal', @qf_open], Setting.nextJudgingRound

    # during quarterfinals
    @today.update_attribute(:value, @qf_open + 1.day)
    assert_equal ['quarterfinal', @qf_open], Setting.nextJudgingRound

    # between quarterfinals and semifinals
    @today.update_attribute(:value, @qf_close + 1.day)
    assert_equal ['semifinal', @sf_open], Setting.nextJudgingRound

    # during semifinals
    @today.update_attribute(:value, @sf_open + 1.day)
    assert_equal ['semifinal', @sf_open], Setting.nextJudgingRound

    # between semifinals and finals
    @today.update_attribute(:value, @sf_close + 1.day)
    assert_equal ['final', @f_open], Setting.nextJudgingRound
  end
end
