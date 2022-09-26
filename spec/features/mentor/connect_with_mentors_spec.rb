require "rails_helper"

RSpec.feature "Mentors connect with other mentors" do
  scenario "A newly onboarded mentor is not searchable by other mentors by default" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)
    visit mentor_profile_path

    expect(page).to have_unchecked_field("mentor_profile_connect_with_mentors")
  end
end