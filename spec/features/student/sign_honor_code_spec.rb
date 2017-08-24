require "rails_helper"

RSpec.feature "Students sign the honor code" do
  scenario "existing student doesn't sign it correctly" do
    student = FactoryGirl.create(:student)
    student.void_honor_code_agreement!

    sign_in(student)
    click_link "Sign the agreement"

    fill_in "Electronic signature", with: "Agreement Duck"
    click_button "Agree"

    expect(page).to have_content("must be checked")

    check "I agree to the honor code as stated above"
    fill_in "Electronic signature", with: ""
    click_button "Agree"

    expect(page).to have_content("can't be blank")
  end
end
