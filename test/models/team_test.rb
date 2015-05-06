require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    super

    @jason = FactoryGirl.create(:user, home_country: 'US')
    @zack = FactoryGirl.create(:user, home_country: 'US')
    @trini = FactoryGirl.create(:user, home_country: 'US')
    @billy = FactoryGirl.create(:user, home_country: 'US')
    @kimberly = FactoryGirl.create(:user, home_country: 'US')

    @tommy = FactoryGirl.create(:user, home_country: 'US')

    @power_rangers = Team.create(
      name: 'Power Rangers',
      year: Setting.year,
      region: 0
    ) # defaults to division 2
  end

  def add_to_team(user, team)
    TeamRequest.create(
      user: user,
      team: team,
      approved: true
    )
  end

  test "toggle division based on team size" do
    @power_rangers.update_team_data!
    assert @power_rangers.ineligible?

    [ @jason, @zack, @trini, @billy, @kimberly ].each do |ranger|
      add_to_team(ranger, @power_rangers)
    end

    @power_rangers.update_team_data!
    assert !@power_rangers.ineligible?

    add_to_team(@tommy, @power_rangers)
    @power_rangers.update_team_data!
    assert @power_rangers.ineligible?
  end
end
