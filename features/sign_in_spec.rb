require 'rails_helper'

feature "SignIn", type: :feature do

  scenario "User sign in" do
    visit "/users/sign_in"
    expect(page).to have_selector(".btn.btn-default")
  end

end
