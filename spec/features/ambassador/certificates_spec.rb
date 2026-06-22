require "rails_helper"

RSpec.feature "Ambassador certificates" do
  let(:season_with_templates) { instance_double(Season, year: 2026) }

  before do
    allow(Season).to receive(:current).and_return(season_with_templates)
  end

  def fully_onboarded_chapter_ambassador
    ambassador = FactoryBot.create(:ambassador, :approved)
    ambassador.update_column(:onboarded, true)
    ambassador.account.current_primary_chapter.update_column(:onboarded, true)
    ambassador
  end

  scenario "certificate page is unavailable when display scores is turned off" do
    SeasonToggles.display_scores_off!

    ambassador = fully_onboarded_chapter_ambassador
    FactoryBot.create(:certificate,
      account: ambassador.account,
      cert_type: :ambassador_appreciation)

    sign_in(ambassador)
    visit chapter_ambassador_certificates_path

    expect(page).to have_content("Certificates are currently unavailable.")
  end

  scenario "chapter ambassador can view their certificate when eligible" do
    SeasonToggles.display_scores_on!

    ambassador = fully_onboarded_chapter_ambassador
    certificate = FactoryBot.create(:certificate,
      account: ambassador.account,
      cert_type: :ambassador_appreciation)

    sign_in(ambassador)
    visit chapter_ambassador_certificates_path

    expect(page).to have_css("#ambassador-certificate")
    expect(page).to have_link("View your certificate")
    expect(certificate).to be_persisted
  end

  scenario "chapter ambassador without a certificate sees a helpful message" do
    SeasonToggles.display_scores_on!

    ambassador = fully_onboarded_chapter_ambassador

    sign_in(ambassador)
    visit chapter_ambassador_certificates_path

    expect(page).to have_content("You don't have a certificate for this season.")
  end

  scenario "club ambassador can view their certificate when eligible" do
    SeasonToggles.display_scores_on!

    ambassador = FactoryBot.create(:club_ambassador)
    ambassador.update_column(:onboarded, true)
    ambassador.account.current_clubs.first.update_column(:onboarded, true)

    certificate = FactoryBot.create(:certificate,
      account: ambassador.account,
      cert_type: :ambassador_appreciation)

    sign_in(ambassador)
    visit club_ambassador_certificates_path

    expect(page).to have_css("#ambassador-certificate")
    expect(page).to have_link("View your certificate")
    expect(certificate).to be_persisted
  end
end
