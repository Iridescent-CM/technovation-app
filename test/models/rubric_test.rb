require 'test_helper'

class RubricTest < ActiveSupport::TestCase
  def setup
    super

    @user = FactoryGirl.create(:user)
    @team = FactoryGirl.create(:team)

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

  test "new rubric works correctly" do
    # Verify: rubrics shouldn't be created in between judging rounds
    #r1 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'quarterfinal', r1.stage

    # After the quarterfinals have started
    @today.update_attribute(:value, @qf_open + 1.day)
    r2 = FactoryGirl.create(:rubric, user: @user, team: @team)
    assert_equal 'quarterfinal', r2.stage

    # After the quarterfinals have closed but before the semifinals have started (?)
    #@today.update_attribute(:value, @qf_close + 1.day)
    #r3 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'semifinal', r3.stage

    # After the semifinals have started
    @today.update_attribute(:value, @sf_open + 1.day)
    r4 = FactoryGirl.create(:rubric, user: @user, team: @team)
    assert_equal 'semifinal', r4.stage

    # After the semifinals have closed, before the finals have started (?)
    #@today.update_attribute(:value, @sf_close + 1.day)
    #r5 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'final', r5.stage
  end
end
