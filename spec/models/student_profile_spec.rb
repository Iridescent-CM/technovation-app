require "rails_helper"

RSpec.describe StudentProfile do
  it "validates erroneous profile attributes" do
    profile = FactoryGirl.build(:student_profile, is_in_secondary_school: "")
    expect(profile).not_to be_valid
    expect(profile.errors[:is_in_secondary_school]).not_to be_nil
  end
end
