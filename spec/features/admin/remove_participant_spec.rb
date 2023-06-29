require "rails_helper"

RSpec.feature "Admins removing participants", :js do
  before do
    sign_in(:admin)
  end

  scenario "Removing a student" do
    student = FactoryBot.create(:student)

    visit admin_participant_path(student.account)

    click_link "Remove #{student.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{student.account.name} was removed from Technovation Girls")
  end

  scenario "Removing a mentor" do
    mentor = FactoryBot.create(:mentor)

    visit admin_participant_path(mentor.account)

    click_link "Remove #{mentor.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{mentor.account.name} was removed from Technovation Girls")
  end

  scenario "Removing a mentor who is also a judge" do
    mentor_judge = FactoryBot.create(:mentor, :has_judge_profile)

    visit admin_participant_path(mentor_judge.account)

    click_link "Remove #{mentor_judge.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{mentor_judge.account.name} was removed from Technovation Girls")
  end

  scenario "Removing a judge" do
    judge = FactoryBot.create(:judge)

    visit admin_participant_path(judge.account)

    click_link "Remove #{judge.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{judge.account.name} was removed from Technovation Girls")
  end

  scenario "Removing a chapter ambassador" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)

    visit admin_participant_path(chapter_ambassador.account)

    click_link "Remove #{chapter_ambassador.account.name} from Technovation Girls"
    click_button "Yes, do it"

    expect(page).to have_content("#{chapter_ambassador.account.name} was removed from Technovation Girls")
  end
end
