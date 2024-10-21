require "rails_helper"

RSpec.feature "Chapter Ambassador viewing unaffiliated participants" do
  let(:chapter) { FactoryBot.create(:chapter, :chicago, :onboarded) }
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

  before do
    chapter_ambassador.chapter_assignments.create(
      account: chapter_ambassador.account,
      chapter: chapter,
      season: Season.current.year
    )
  end

  scenario "displays unaffiliated students and mentors in the ambassador's country" do
    unaffiliated_student = FactoryBot.create(:student, :chicago, :unaffiliated)
    unaffiliated_mentor = FactoryBot.create(:mentor, :chicago, :unaffiliated)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)
    expect(page).to have_content(unaffiliated_student.account.email)
    expect(page).to have_content(unaffiliated_mentor.account.email)
  end

  scenario "does not display unaffiliated students or mentors located in a different country that the ambassador" do
    unaffiliated_student = FactoryBot.create(:student, :brazil, :unaffiliated)
    unaffiliated_mentor = FactoryBot.create(:mentor, :brazil, :unaffiliated)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)
    expect(page).not_to have_content(unaffiliated_student.account.email)
    expect(page).not_to have_content(unaffiliated_mentor.account.email)
  end

  scenario "does not display affiliated students or mentors in the ambassador's chapter" do
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

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)

    expect(page).not_to have_content(affiliated_student.account.email)
    expect(page).not_to have_content(affiliated_mentor.account.email)
    visit(chapter_ambassador_participants_path)
  end
end
