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

    within("#cert_appreciation") { click_button("Prepare my certificate") }

    expect(page).to have_link("Download my certificate",
                              href: mentor.certificates.appreciation.current.file_url)
  end
end
