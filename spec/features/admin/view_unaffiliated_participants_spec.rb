require "rails_helper"

RSpec.feature "Admin viewing unaffiliated participants" do
  let(:admin) { FactoryBot.create(:admin) }

  scenario "displays unaffiliated students and mentors in any country" do
    unaffiliated_student = FactoryBot.create(:student, :chicago, :unaffiliated)
    unaffiliated_mentor = FactoryBot.create(:mentor, :brazil, :unaffiliated)

    sign_in(admin)
    visit(admin_unaffiliated_participants_path)

    expect(page).to have_content(unaffiliated_student.account.country)
    expect(page).to have_content(unaffiliated_mentor.account.country)
  end

  scenario "does not display students or mentors assigned to a chapter" do
    chapter = FactoryBot.create(:chapter, :chicago, :onboarded)

    affiliated_student = FactoryBot.create(:student, :chicago)
    affiliated_student.chapter_assignments.create(
      account: affiliated_student.account,
      chapter: chapter,
      season: Season.current.year
    )

    affiliated_mentor = FactoryBot.create(:mentor, :chicago)
    affiliated_mentor.chapter_assignments.create(
      account: affiliated_mentor.account,
      chapter: chapter,
      season: Season.current.year
    )

    sign_in(admin)
    visit(admin_unaffiliated_participants_path)

    expect(page).not_to have_content(affiliated_student.account.email)
    expect(page).not_to have_content(affiliated_mentor.account.email)
  end
end
