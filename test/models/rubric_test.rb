require 'test_helper'

class RubricTest < ActiveSupport::TestCase
  def setup
    super

    @user = FactoryGirl.create(:user)
    @team = FactoryGirl.create(:team)

    @dates = create_judging_date_settings(Date.new(2015, 1, 1))

    @today = Setting.create!(key: 'todaysDateForTesting', value: @dates[:qf_open] - 1.day)
  end

  test "new rubric works correctly" do
    # Verify: rubrics shouldn't be created in between judging rounds
    #r1 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'quarterfinal', r1.stage

    # After the quarterfinals have started
    @today.update_attribute(:value, @dates[:qf_open] + 1.day)
    r2 = FactoryGirl.create(:rubric, user: @user, team: @team)
    assert_equal 'quarterfinal', r2.stage

    # After the quarterfinals have closed but before the semifinals have started (?)
    #@today.update_attribute(:value, @dates[:qf_close] + 1.day)
    #r3 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'semifinal', r3.stage

    # After the semifinals have started
    @today.update_attribute(:value, @dates[:sf_open] + 1.day)
    r4 = FactoryGirl.create(:rubric, user: @user, team: @team)
    assert_equal 'semifinal', r4.stage

    # After the semifinals have closed, before the finals have started (?)
    #@today.update_attribute(:value, @dates[:sf_close] + 1.day)
    #r5 = FactoryGirl.create(:rubric, user: @user, team: @team)
    #assert_equal 'final', r5.stage
  end
end
