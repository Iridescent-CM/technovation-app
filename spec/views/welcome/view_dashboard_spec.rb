require 'rails_helper'

RSpec.feature "view dashboard" do
  let!(:student) { create(:user, :student) }

  scenario "shows pre program survey link for students" do
    Season.open!
    Submissions.open!

    sign_in(student)
    visit root_path
    expect(page).to have_link('', href: root_path("survey-link") )
  end

end
