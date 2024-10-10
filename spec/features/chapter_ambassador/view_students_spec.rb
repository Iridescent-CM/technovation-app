require "rails_helper"

RSpec.feature "chapter ambassadors view student profile pages" do
  scenario "viewing a new student that belongs to the chapter ambassador's chapter" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)
    student = FactoryBot.create(:student)
    student.chapter_assignments.create(
      chapter: chapter_ambassador.current_chapter,
      account: student.account,
      season: Season.current.year
    )

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Participants"
    within("tr#account_#{student.account_id}") { click_link "view" }

    expect(current_path).to eq(chapter_ambassador_participant_path(student.account))
    expect(page).to have_css(
      ".flag.flag--season.flag-season--new",
      text: "New student"
    )
  end

  scenario "viewing a past student that belongs to the chapter ambassador's chapter" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)
    student = FactoryBot.create(:student, :past)
    student.chapter_assignments.create(
      chapter: chapter_ambassador.current_chapter,
      account: student.account,
      season: Season.current.year - 1
    )

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Participants"
    visit chapter_ambassador_participant_path(student.account)

    expect(page).to have_css(
      ".flag.flag--season.flag-season--past",
      text: "Past student"
    )
  end

  scenario "viewing a returning student that belongs to the chapter ambassador's chapter" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)
    student = FactoryBot.create(:student, :returning)
    student.chapter_assignments.create(
      chapter: chapter_ambassador.current_chapter,
      account: student.account,
      season: Season.current.year
    )

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Participants"
    visit chapter_ambassador_participant_path(student.account)

    expect(page).to have_css(
      ".flag.flag--season.flag-season--returning",
      text: "Returning student"
    )
  end
end
