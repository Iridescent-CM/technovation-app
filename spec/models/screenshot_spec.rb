require "rails_helper"

RSpec.describe Screenshot do
  it "sets sort position before creating" do
    screenshot1 = Screenshot.create!
    screenshot2 = Screenshot.create!

    expect(screenshot1.sort_position).to be_zero
    expect(screenshot2.sort_position).to eq(1)
  end

  it "does not change position on saving" do
    screenshot1 = Screenshot.create!

    Screenshot.create!
    screenshot1.save

    expect(screenshot1.reload.sort_position).to be_zero
  end
end
