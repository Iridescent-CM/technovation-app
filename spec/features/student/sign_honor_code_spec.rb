require "rails_helper"

RSpec.feature "Students sign the honor code" do
  scenario "existing student is interrupted to sign it" do
    student = FactoryGirl.create(:student)
    student.void_honor_code_agreement!

    sign_in(student)
    visit new_student_team_path
    click_link "Sign the Technovation Honor Code"

    expect(page).to have_content("you promise that all elements of your #{Season.current.year} Technovation submission")

    check "I agree to the honor code as stated above"
    fill_in "Electronic signature", with: "Agreement Duck"
    click_button "Agree"

    expect(student.reload.honor_code_signed?).to be true
    expect(HonorCodeAgreement.last.account_id).to eq(student.account_id)
  end

  scenario "existing student doesn't sign it correctly" do
    student = FactoryGirl.create(:student)
    student.void_honor_code_agreement!

    sign_in(student)
    visit new_student_team_path
    click_link "Sign the Technovation Honor Code"

    fill_in "Electronic signature", with: "Agreement Duck"
    click_button "Agree"

    expect(page).to have_content("must be checked")

    check "I agree to the honor code as stated above"
    fill_in "Electronic signature", with: ""
    click_button "Agree"

    expect(page).to have_content("can't be blank")
  end
end
