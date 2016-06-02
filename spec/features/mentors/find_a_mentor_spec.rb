require 'rails_helper'

RSpec.feature "Find a mentor" do
  let!(:student) { create(:user, :student) }
  let!(:us_mentor_ok) { create(:mentor, home_country: "US")  }
  let!(:us_mentor_not_ok) { create(:mentor, :with_fake_checker_not_ok, home_country: "US" )  }
  let!(:non_us_mentor) { create(:user, role: :mentor) }

  before do
    Season.open!
    Submissions.open!
  end

  scenario "show all valid mentors" do
    sign_in(student)
    visit mentors_path
    expect(page).to have_link(us_mentor_ok.name)
    expect(page).to have_link(non_us_mentor.name)
    expect(page).to_not have_link(us_mentor_not_ok.name)
  end
end
