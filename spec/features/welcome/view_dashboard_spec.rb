require 'rails_helper'
require './app/models/survey/survey.rb'

RSpec.feature "view dashboard" do
  let!(:student) { create(:user, :student) }
  let(:judge) { create(:user, :judge) }

  before do
    Season.open!
    Submissions.open!
  end

  scenario "shows pre program survey link for students" do
    Survey.show_pre_program
    sign_in(student)
    visit root_path
    expect(page).to have_link('survey-link')
  end

  scenario "does not show survey link for judges" do
    Quarterfinal.open!(close: Date.today + 1)
    Semifinal.close!
    Survey.show_post_program

    sign_in(judge)
    visit root_path
    expect(page).not_to have_link('survey-link')
  end

  scenario "does not show survey link when they are not visible" do
    Survey.hide_all

    sign_in(student)
    visit root_path
    expect(page).not_to have_link('survey-link')
  end
end
