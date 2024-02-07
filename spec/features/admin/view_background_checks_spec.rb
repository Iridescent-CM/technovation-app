require "rails_helper"

RSpec.feature "Admin view background check datagrid", js: true do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    us_based_mentors =  FactoryBot.create_list(:mentor, 2, :geocoded)
    india_based_mentors = FactoryBot.create_list(:mentor, 2, :india)

    india_based_mentors.each do |mentor|
      mentor.background_check.destroy
      FactoryBot.create(
        :background_check,
        :invitation_pending,
        account: mentor.account
      )
    end

    @all_mentors = us_based_mentors + india_based_mentors

    sign_in(admin)
    visit admin_background_checks_path
  end

  scenario "Clicking on admin background checks link displays a datagrid of all background checks" do
    page.save_and_open_page
    expect(page).to have_content("#{@all_mentors.size} background checks found")

    @all_mentors.each do |mentor|
      expect(page).to have_link(mentor.account.name, href: admin_participant_path(mentor.account))

      expect(page).to have_selector("tr#background_check_#{mentor.background_check.id}")

      within("tr#background_check_#{mentor.background_check.id}") do
        expect(page).to have_css("td.background_check", text: mentor.background_check.status.titleize)

        invitation_status_text = mentor.account.country_code == "US" ? "-" : mentor.background_check.invitation_status.titleize
        expect(page).to have_css("td.invitation_status", text: invitation_status_text)
      end
    end
  end
end
