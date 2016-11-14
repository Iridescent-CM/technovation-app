require "rails_helper"

RSpec.feature "RAs reading profiles" do
  scenario  "do not see unapproved RAs" do
    pending_ra = FactoryGirl.create(:ambassador, first_name: "Pending", status: :pending)
    approved_ra = FactoryGirl.create(:ambassador, first_name: "Approved", status: :approved)
    declined_ra = FactoryGirl.create(:ambassador, first_name: "Declined", status: :declined)
    spam_ra = FactoryGirl.create(:ambassador, first_name: "Spammed", status: :spam)

    student = FactoryGirl.create(:student, first_name: "Student")
    judge = FactoryGirl.create(:judge, first_name: "Judge")
    mentor = FactoryGirl.create(:mentor, first_name: "Mentor")

    sign_in(approved_ra)

    visit regional_ambassador_profiles_path

    expect(page).to have_content(student.full_name)
    expect(page).to have_content(mentor.full_name)
    expect(page).to have_content(judge.full_name)

    expect(page).not_to have_content(pending_ra.full_name)
    expect(page).not_to have_content(declined_ra.full_name)
    expect(page).not_to have_content(spam_ra.full_name)
  end
end
