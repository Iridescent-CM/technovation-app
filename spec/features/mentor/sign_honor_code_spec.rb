require "rails_helper"

RSpec.feature "Mentors sign the honor code" do
  scenario "existing mentor is interrupted to sign it" do
    mentor = FactoryGirl.create(:mentor)
    mentor.void_honor_code_agreement!

    sign_in(mentor)
    visit new_mentor_team_path
    click_link "Sign the Technovation Honor Code"

    expect(page).to have_content("you promise that all elements of your #{Season.current.year} Technovation submission")

    check "I agree to the statement above"
    fill_in "Electronic signature", with: "Agreement Duck"
    click_button "Agree"

    expect(mentor.reload.honor_code_signed?).to be true
    expect(HonorCodeAgreement.last.account_id).to eq(mentor.account_id)
  end

  scenario "existing mentor doesn't sign it correctly" do
    mentor = FactoryGirl.create(:mentor)
    mentor.void_honor_code_agreement!

    sign_in(mentor)
    visit new_mentor_team_path
    click_link "Sign the Technovation Honor Code"

    fill_in "Electronic signature", with: "Agreement Duck"
    click_button "Agree"

    expect(page).to have_content("must be checked")

    check "I agree to the statement above"
    fill_in "Electronic signature", with: ""
    click_button "Agree"

    expect(page).to have_content("can't be blank")
  end
end
