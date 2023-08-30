require "rails_helper"

RSpec.describe "Verifying a student's age" do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_YEAR", any_args).and_return(Time.current.year)
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_MONTH", any_args).and_return(8)
    allow(ENV).to receive(:fetch).with("DATES_DIVISION_CUTOFF_DAY", any_args).and_return(1)
  end

  context "when a returning student is older than 18 years old by the cut-off date" do
    let(:student) { FactoryBot.create(:student, :returning, date_of_birth: 20.years.ago) }

    before do
      sign_in(student)
    end

    it "redirects to the `student_mentor_conversion_path`" do
      expect(current_path).to eq(student_mentor_conversion_path)
    end

    it "displays a 'Become a Mentor' link" do
      expect(page).to have_link "Become a Mentor"
    end
  end

  context "when a student is younger than 18 years old by the cut-off date" do
    let(:student) { FactoryBot.create(:student, date_of_birth: 15.years.ago) }

    before do
      sign_in(student)
    end

    it "redirects to the student dashboard" do
      expect(current_path).to eq(student_dashboard_path)
    end
  end
end
