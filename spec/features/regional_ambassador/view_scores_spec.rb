require "rails_helper"

RSpec.feature "Regional Ambassador views scores" do
  before do
    @ra_scores_enabled = ENV.fetch("ENABLE_RA_SCORES") { false }
    ENV["ENABLE_RA_SCORES"] = "yes"
  end

  after do
    if !!@ra_scores_enabled
      ENV["ENABLE_RA_SCORES"] = @ra_scores_enabled
    end
  end

  scenario "RA can't pick finals scores, as there is no such thing" do
    ra = FactoryGirl.create(:regional_ambassador, :approved)
    sign_in(ra)
    click_link "Scores"
    options = page.find('[name=round]').all('option')
    expect(options.map(&:value)).not_to include("finals")
  end
end
