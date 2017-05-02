require "rails_helper"

RSpec.describe Screenshot do
	let(:sub) { FactoryGirl.create(:team_submission) }

  it "sets sort position before creating" do
    screenshot1 = sub.screenshots.create!
    screenshot2 = sub.screenshots.create!

    expect(screenshot1.sort_position).to be_zero
    expect(screenshot2.sort_position).to eq(1)
  end

  it "does not change position on saving" do
    screenshot1 = sub.screenshots.create!

    sub.screenshots.create!
    screenshot1.save

    expect(screenshot1.reload.sort_position).to be_zero
  end
end
