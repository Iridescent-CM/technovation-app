require "rails_helper"

RSpec.feature "Parental consent" do
  scenario "sort of invalid email" do
    student = FactoryBot.create(:onboarding_student)

    sign_in(student)
    click_link "Enter parent/guardian name & email"
    fill_in "Parent or guardian's email", with: "no-work"

    click_button "Send the link"

    expect(page).to have_css(
      '.error',
      text: "does not appear to be an email address"
    )

    fill_in "Parent or guardian's email", with: "no-work@gmail.com."

    click_button "Send the link"

    expect(page).to have_css(
      '.error',
      text: "does not appear to be an email address"
    )
  end

  scenario "invalid token" do
    [{ }, { token: "bad" }].each do |bad_token_params|
      visit edit_parental_consent_path(bad_token_params)
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Sorry, that consent token was invalid.")
    end
  end

  scenario "valid token, invalid signature form" do
    student = FactoryBot.create(:onboarding_student)

    visit edit_parental_consent_path(token: student.consent_token)

    click_button "I agree"

    expect(current_path).to eq(parental_consent_path(student.parental_consent))
    expect(page).to have_css(
      '.parental_consent_electronic_signature .error',
      text: "can't be blank"
    )
  end

  scenario "valid token, valid form" do
    student = FactoryBot.create(:onboarding_student)
    visit edit_parental_consent_path(token: student.reload.consent_token)

    fill_in "Your name", with: "Parent M. McGee"
    click_button "I agree"

    expect(current_path).to eq(parental_consent_path(student.parental_consent))
    expect(page).to have_content(
      "#{student.full_name} has been consented by #{student.parental_consent_electronic_signature} on #{student.parental_consent_signed_at.strftime("%-d %B, %Y")}"
    )
  end

  scenario "fill it out on dashboard steps" do
    student = FactoryBot.create(:onboarding_student)

    sign_in(student)
    click_link "Enter parent/guardian name & email"

    fill_in "Parent or guardian's name", with: "Parent name"
    fill_in "Parent or guardian's email", with: "parent@parent.com"
    click_button "Send the link"

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no parent email sent"
    expect(mail.to).to eq(["parent@parent.com"])
    expect(mail.subject).to include("Your daughter needs permission")
  end

  scenario "validate parental consent info" do
    student = FactoryBot.create(:onboarding_student)

    sign_in(student)
    click_link "Enter parent/guardian name & email"

    fill_in "Parent or guardian's name", with: ""
    fill_in "Parent or guardian's email", with: ""
    click_button "Send the link"

    expect(page).to have_content("can't be blank")
  end
end
