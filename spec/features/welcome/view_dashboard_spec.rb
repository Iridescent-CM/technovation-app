require 'rails_helper'

RSpec.feature "view dashboard" do
  let!(:student) { create(:user, :student) }
  let(:judge) { create(:user, :judge) }

  before do
    Season.open!
    Submissions.open!
  end

  scenario "shows pre program survey link for students" do
    sign_in(student)
    visit root_path
    expect(page).to have_link('survey-link')
  end

  scenario "does not show pre program survey link for judges" do
    Quarterfinal.open!(close: Date.today + 1)
    Semifinal.close!

    sign_in(judge)
    visit root_path
    expect(page).not_to have_link('survey-link')
  end
end
