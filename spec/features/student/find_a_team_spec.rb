require "rails_helper"

RSpec.feature "Students find a team" do
  let(:day_before_qfs) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(day_before_qfs.year) }

  before { allow(Season).to receive(:current).and_return(current_season) }
  before { SeasonToggles.team_building_enabled! }

  before(:all) do
    @wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 15
  end

  after(:all) do
    Capybara.default_max_wait_time = @wait_time
  end

  let!(:available_team) { FactoryBot.create(:team, :geocoded) }
    # Default is in Chicago

  before do
    student = FactoryBot.create(:student, :geocoded, :onboarded)
      # City is Chicago
    sign_in(student)
  end

  xcontext "as a Student" do
    xdescribe do
      it "browse nearby teams" do
        team = FactoryBot.create(:team, :geocoded) # Default is in Chicago
  
        faraway_team = FactoryBot.create(
          :team,
          :geocoded,
          city: "Los Angeles",
          state_province: "CA"
        )
    
        within(".sub-nav-wrapper") { click_link "Find a team" }
    
        expect(page).to have_css(".card-title", text: team.name)
      end
    end
  end
end
