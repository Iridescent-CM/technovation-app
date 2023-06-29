require "rails_helper"

RSpec.feature "Chapter ambassadors removing participants", :js do
  before do
    sign_in(:chapter_ambassador, :approved)
  end

  scenario "Removing a student" do
    student = FactoryBot.create(:student)

    visit chapter_ambassador_participant_path(student.account)

    click_link "Remove #{student.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{student.account.name} was removed from Technovation Girls")
  end

  scenario "Removing a mentor" do
    mentor = FactoryBot.create(:mentor)

    visit chapter_ambassador_participant_path(mentor.account)

    click_link "Remove #{mentor.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{mentor.account.name} was removed from Technovation Girls")
  end

  scenario "When trying to remove a judge who is also a judge, the remove button is not displayed" do
    mentor_judge = FactoryBot.create(:mentor, :has_judge_profile)

    visit chapter_ambassador_participant_path(mentor_judge.account)

    expect(page).not_to have_button "Remove #{mentor_judge.account.name} from Technovation Girls"
  end

  scenario "When trying to remove a judge, the remove button is not displayed" do
    judge = FactoryBot.create(:judge)

    visit chapter_ambassador_participant_path(judge.account)

    expect(page).not_to have_button "Remove #{judge.account.name} from Technovation Girls"
  end

  scenario "When trying to remove a chapter ambassador, the remove button is not displayed" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

    visit chapter_ambassador_participant_path(chapter_ambassador.account)

    expect(page).not_to have_button "Remove #{chapter_ambassador.account.name} from Technovation Girls"
  end
end
