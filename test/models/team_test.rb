require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    super

    @jason = FactoryGirl.create(:user)
    @zack = FactoryGirl.create(:user)
    @trini = FactoryGirl.create(:user)
    @billy = FactoryGirl.create(:user)
    @kimberly = FactoryGirl.create(:user)

    @tommy = FactoryGirl.create(:user)

    @age_13_birthday = 13.years.ago
    @age_17_birthday = 17.years.ago
    @age_22_birthday = 22.years.ago

    @power_rangers = Team.create(
      name: 'Power Rangers',
      year: Setting.year,
      region: 0
    ) # defaults to division 2

    [ @jason, @zack, @trini, @billy, @kimberly ].each do |ranger|
      add_to_team(ranger, @power_rangers)
    end
  end

  def add_to_team(user, team)
    TeamRequest.create(
      user: user,
      team: team,
      approved: true
    )
  end

  test "toggle division based on team size" do
    new_power_rangers = Team.create(
      name: 'New Power Rangers',
      year: Setting.year,
      region: 0
    )

    new_power_rangers.update_team_data!
    assert new_power_rangers.ineligible?

    [ @jason, @zack, @trini, @billy, @kimberly ].each do |ranger|
      add_to_team(ranger, new_power_rangers)
    end

    new_power_rangers.update_team_data!
    assert !new_power_rangers.ineligible?

    add_to_team(@tommy, new_power_rangers)
    new_power_rangers.update_team_data!
    assert new_power_rangers.ineligible?
  end

  test "calculate division: all middle schoolers" do
    [ @jason, @zack, @trini, @billy, @kimberly ].each do |ranger|
      ranger.update_attribute(:birthday, @age_13_birthday)
    end

    @power_rangers.update_team_data!
    assert_equal 'ms', @power_rangers.division
  end

  test "calculate division: mostly middle schoolers" do
    assert !@power_rangers.ineligible?

    [ @jason, @zack, @trini, @billy ].each do |ranger|
      ranger.update_attribute(:birthday, @age_13_birthday)
    end
    @kimberly.update_attribute(:birthday, @age_17_birthday)

    @power_rangers.update_team_data!
    assert_equal 'hs', @power_rangers.division
  end

  test "calculate division: all high schoolers" do
    [ @jason, @zack, @trini, @billy, @kimberly ].each do |ranger|
      ranger.update_attribute(:birthday, @age_17_birthday)
    end

    @power_rangers.update_team_data!
    assert_equal 'hs', @power_rangers.division
  end

  test "calculate division: mostly high schoolers" do
    [ @jason, @zack, @trini, @billy ].each do |ranger|
      ranger.update_attribute(:birthday, @age_17_birthday)
    end
    @kimberly.update_attribute(:birthday, @age_22_birthday)

    @power_rangers.update_team_data!
    assert @power_rangers.ineligible?
  end

  test "set team country based on members" do
    assert_equal 'US', @power_rangers.country

    [ @trini, @kimberly, @billy ].each do |ranger|
      ranger.update_attribute(:home_country, 'JP')
    end

    @power_rangers.update_team_data!
    assert_equal 'JP', @power_rangers.country
  end
end
