require "rails_helper"

RSpec.feature "Admins managing clubs", :js do
  before do
    sign_in(:admin)

    Club.destroy_all
  end

  scenario "Admin add a club" do
    visit admin_clubs_path
    click_link "Setup a new club"

    fill_in "name", with: "Hello World"
    expect(page).to have_field("name", with: "Hello World")

    click_button "Add"

    expect(page).to have_content("Hello World")
    expect(Club.count).to eq(1)
  end

  scenario "Admin view all clubs" do
    clubs = FactoryBot.create_list(:club, 2)
    visit admin_clubs_path

    clubs.each do |club|
      expect(page).to have_selector("tr#club_#{club.id}")
      within("tr#club_#{club.id}") do
        expect(page).to have_link("View", href: admin_club_path(club))
      end
    end
  end
end
