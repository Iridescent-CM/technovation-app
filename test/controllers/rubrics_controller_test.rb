require 'test_helper'

class RubricsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    super

    @me = FactoryGirl.create(:user, judging_region: 0)
    sign_in @me

    @dates = create_judging_date_settings(Date.new(2015, 1, 1))

    @today = Setting.create!(key:'todaysDateForTesting', value: @dates[:qf_open])
    @qfs = Event.create!(name: 'Virtual Judging') # quarterfinals
  end

  def create_team(name, options = {})
    has_judged = !!options.delete(:has_judged)
    num_rubrics = options.delete(:num_rubrics).to_i

    if has_judged && num_rubrics == 0
      raise "If the current user has judged this team, there must be at least 1 rubric"
    end

    team = FactoryGirl.create(:team,
      {
        name: name,
        event_id: @qfs.id,
        division: 0,
        region: @me.judging_region
      }.merge(options))
    if has_judged
      FactoryGirl.create(:rubric, team: team, user: @me)
      num_rubrics -= 1
    end
    num_rubrics.times do
      u = FactoryGirl.create(:user, judging_region: 0)
      FactoryGirl.create(:rubric, team: team, user: u)
    end

    team
  end

  test "blank slate" do
    @today.value = @dates[:qf_open] - 1.day
    @today.save!

    assert !Setting.anyJudgingRoundActive?

    get :index
    assert_response :success

    assert assigns(:rubrics).empty?

    assert_select "div.loggedin h1", "Judge dashboard"
    assert_select "div.loggedin h3", false, "No judging round active"
    assert_select "div.loggedin h4", /No judging rounds/
    assert_select "div.loggedin a", false
  end

  test "simple quarterfinals case" do
    power_rangers = create_team("Power Rangers", num_rubrics: 1)
    create_team("The Avengers", num_rubrics: 3)
    create_team("Golden Oldies", division: 2) # div 'x' = dq'ed

    get :index
    assert_response :success

    assert assigns(:rubrics).empty?
    assert_not_nil assigns(:teams)

    assert_select "div.loggedin h3", /quarterfinals/

    # Should skip Golden Oldies due to invalid division
    # Should skip Avengers because it has more rubrics already
    assert_equal power_rangers.name, assigns(:teams).first.name
  end

  test "should hide teams that i've judged already" do
    power_rangers = create_team("Power Rangers", num_rubrics: 1, has_judged: true)
    create_team("The Avengers", num_rubrics: 3)
    powerpuff_girls = create_team("PowerPuff Girls", num_rubrics: 2)

    get :index
    assert_response :success

    assert_equal 1, assigns(:rubrics).size
    assert_not_nil assigns(:teams)

    assert_equal powerpuff_girls.name, assigns(:teams).first.name
    assert_equal power_rangers.name, assigns(:rubrics).first.team.name
  end

  test "ensure multiple rubrics are handled correctly" do
    avengers = create_team("The Avengers", num_rubrics: 3)
    powerpuff_girls = create_team("PowerPuff Girls", num_rubrics: 2)
    power_rangers = create_team("Power Rangers", num_rubrics: 1, has_judged: true)

    FactoryGirl.create(:rubric, team: powerpuff_girls, user: @me)
    FactoryGirl.create(:rubric, team: avengers, user: @me)

    get :index
    assert_response :success
    assert_nil assigns(:teams)
    rubrics = assigns(:rubrics)
    assert_equal 3, rubrics.size
    assert_equal power_rangers.name, rubrics[2].team.name
    assert_equal powerpuff_girls.name, rubrics[1].team.name
    assert_equal avengers.name, rubrics[0].team.name
  end

  test "semifinals, not marked as judge" do
    @today.value = @dates[:sf_open]
    @today.save!

    create_team("The Avengers", issemifinalist: true)

    get :index
    assert_response :success

    # Maybe this h3 shouldn't be visible if !user.semifinals_judge?
    assert_select "div.loggedin h3", /semifinals/
    assert_nil assigns(:teams)
  end

  test "semifinals, marked as judge" do
    @today.value = @dates[:sf_open]
    @today.save!

    @me.update_attribute(:semifinals_judge, true)

    create_team("Watchmen")
    avengers = create_team("The Avengers", issemifinalist: true)

    get :index
    assert_response :success

    # Maybe this h3 shouldn't be visible if !user.semifinals_judge?
    assert_select "div.loggedin h3", /semifinals/
    # Should skip Watchmen because it's not a semifinalist
    assert_equal avengers.name, assigns(:teams).first.name
  end

  test "inbetween date" do
    # in between semifinal judging close and final judging open
    @today.value = @dates[:sf_close] + 1.day
    @today.save!

    create_team("Watchmen")
    create_team("The Pitches")

    assert !Setting.anyJudgingRoundActive?

    get :index
    assert_response :success

    assert_select "div.loggedin h4", /No judging rounds/

    assert assigns(:rubrics).empty?
    assert_nil assigns(:teams)
  end

  test "in-person events - defer to event when active" do
    event = Event.create(
      name: 'Bay Area Quarterfinals',
      whentooccur: Setting.now
    )
    @me.event_id = event.id

    create_team("Watchmen")
    tmnt = create_team("Teenage Mutant Ninja Turtles", event: event)

    get :index
    assert_response :success

    assert_equal tmnt.name, assigns(:teams).first.name
  end

  test "in-person events - ignore assigned event if not active" do
    event = Event.create(
      name: 'Bay Area Quarterfinals',
      whentooccur: @dates[:f_open]
    )
    @me.event_id = event.id

    watchmen = create_team("Watchmen")
    create_team("Teenage Mutant Ninja Turtles", event: event)

    get :index
    assert_response :success

    assert_equal watchmen.name, assigns(:teams).first.name
  end
end
