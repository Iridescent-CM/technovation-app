require "rails_helper"

RSpec.feature "Students converting to a mentor" do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_YEAR", any_args).and_return(Time.current.year)
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_MONTH", any_args).and_return(8)
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_DAY", any_args).and_return(1)
  end

  let(:student) { FactoryBot.create(:student, :returning, date_of_birth: 20.years.ago) }

  before do
    sign_in(student)
  end

  scenario "A student successfully converting to be a mentor" do
    click_link "Become a Mentor"

    expect(current_path).to eq(mentor_dashboard_path)
    expect(page).to have_content "You are now a mentor!"
  end
end
