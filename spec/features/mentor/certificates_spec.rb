require "rails_helper"

RSpec.feature "Mentor certificates" do
  before do
    @original_certificates = ENV["CERTIFICATES"]
    ENV["CERTIFICATES"] = "any value -- booleans don't work in ENV"
  end

  after do
    if @original_certificates.blank?
      ENV.delete("CERTIFICATES")
    end
  end

  scenario "generate an appreciation cert" do
    mentor = FactoryGirl.create(:mentor, :on_team)

    sign_in(mentor)

    click_button("Prepare my certificate")
    expect(page).to have_link("Download my Technovation Certificate",
                              href: mentor.certificates.current.file_url)
  end

  scenario "generate a regional grand prize cert"
end
