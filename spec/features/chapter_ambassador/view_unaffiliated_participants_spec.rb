require "rails_helper"

RSpec.feature "Chapter Ambassador viewing unaffiliated participants" do
  let(:chapter) { FactoryBot.create(:chapter, :chicago, :onboarded) }
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

  before do
    chapter_ambassador.chapter_assignments.create(
      account: chapter_ambassador.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )
  end

  scenario "displays unaffiliated students and mentors in the ambassador's country" do
    unaffiliated_student = FactoryBot.create(:student, :chicago, :unaffiliated_chapter)
    unaffiliated_mentor = FactoryBot.create(:mentor, :chicago, :unaffiliated_chapter)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)
    expect(page).to have_content(unaffiliated_student.account.email)
    expect(page).to have_content(unaffiliated_mentor.account.email)
  end

  scenario "does not display unaffiliated students or mentors located in a different country than the ambassador" do
    unaffiliated_student = FactoryBot.create(:student, :brazil, :unaffiliated_chapter)
    unaffiliated_mentor = FactoryBot.create(:mentor, :brazil, :unaffiliated_chapter)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)
    expect(page).not_to have_content(unaffiliated_student.account.email)
    expect(page).not_to have_content(unaffiliated_mentor.account.email)
  end

  scenario "does not display affiliated students or mentors assigned to the ambassador's chapter" do
    affiliated_student = FactoryBot.create(:student, :chicago)
    affiliated_student.chapter_assignments.create(
      account: affiliated_student.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    affiliated_mentor = FactoryBot.create(:mentor, :chicago)
    affiliated_mentor.chapter_assignments.create(
      account: affiliated_mentor.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_unaffiliated_participants_path)

    expect(page).not_to have_content(affiliated_student.account.email)
    expect(page).not_to have_content(affiliated_mentor.account.email)
  end
end
