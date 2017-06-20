require "rails_helper"

RSpec.feature "Regional Ambassador views scores" do
  scenario "RA can't pick finals scores, as there is no such thing" do
    ra = FactoryGirl.create(:regional_ambassador, :approved)
    sign_in(ra)
    click_link "Scores"
    options = page.find('[name=round]').all('option')
    expect(options.map(&:value)).not_to include("finals")
  end
end
