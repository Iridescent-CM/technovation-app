require "rails_helper"

RSpec.feature "Regional Ambassadors registration" do
  scenario "sign up a valid account" do
    visit signup_path
    click_link "Regional Ambassador sign up"
  end
end
