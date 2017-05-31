require "rails_helper"

RSpec.feature "Student certificates" do
  before do
    @original_certificates = ENV["CERTIFICATES"]
    ENV["CERTIFICATES"] = "a present value -- booleans don't work"
  end

  after do
    if @original_certificates.blank?
      ENV.delete("CERTIFICATES")
    end
  end

  scenario "generate a completion cert" do
    student = FactoryGirl.create(:student, :on_team)
    FactoryGirl.create(:team_submission, :complete, team: student.team)

    sign_in(student)

    click_button("Generate my completion certificate")
    expect(page).to have_link("Download my Technovation Certificate",
                              href: student.certificates.current.file_url)
  end

  scenario "generate a regional grand prize cert"
end
