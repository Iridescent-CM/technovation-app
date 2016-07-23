require "rails_helper"

RSpec.feature "Find a mentor" do
  scenario "See the list of mentors" do
    mentor = FactoryGirl.create(:mentor, :with_expertises)
    student = FactoryGirl.create(:student, :on_team)

    sign_in(student)
    click_link "Find a mentor"

    within('.mentor') do
      expect(page).to have_link(mentor.full_name, href: student_mentor_path(mentor))

      mentor.expertises.pluck(:name).each do |expertise_name|
        expect(page).to have_css('.mentor_expertise', text: expertise_name)
      end
    end
  end
end
