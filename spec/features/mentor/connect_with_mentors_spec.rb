require "rails_helper"

RSpec.feature "Mentors connect with other mentors" do
  scenario "A mentor has finished onboarding and views their profile for the first time" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)
    visit mentor_profile_path

    expect(page).to have_unchecked_field("mentor_profile_connect_with_mentors")
  end
end