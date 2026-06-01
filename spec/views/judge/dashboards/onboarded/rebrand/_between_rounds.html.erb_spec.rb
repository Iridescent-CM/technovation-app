require "rails_helper"

RSpec.describe "judge/dashboards/onboarded/rebrand/_between_rounds.en.html.erb", type: :view do
  before do
    allow(ImportantDates).to receive(:semifinals_judging_begins)
      .and_return(Time.zone.local(2026, 6, 1))
    allow(ImportantDates).to receive(:semifinals_judging_ends)
      .and_return(Time.zone.local(2026, 6, 17))
    allow(ImportantDates).to receive(:certificates_available)
      .and_return(Time.zone.local(2026, 6, 20))
    allow(Season).to receive(:current).and_return(double(year: 2026))

    render partial: "judge/dashboards/onboarded/rebrand/between_rounds"
  end

  it "renders the existing 'You finished quarterfinals!' section" do
    expect(rendered).to include("You finished quarterfinals!")
  end

  it "renders the 'What happens next?' section" do
    expect(rendered).to include("What happens next?")
  end

  it "renders the 'Judge Levels' section" do
    expect(rendered).to include("Judge Levels")
  end

  it "does not render the removed 'View our' Judge Resource page sentence" do
    expect(rendered).not_to include("View our")
    expect(rendered).not_to include("Judge Resource page")
    expect(rendered).not_to include("technovationchallenge.org/judge-resources")
  end
end
