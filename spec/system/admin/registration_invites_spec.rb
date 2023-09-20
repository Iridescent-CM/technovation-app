require "rails_helper"

RSpec.describe "Registration invites", :js do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in(admin)
  end

  %i[student mentor judge chapter_ambassador].each do |profile_type|
    let(:email_address) { "#{profile_type}@example.com" }

    context "when an admin invites a #{profile_type.to_s.humanize(capitalize: false)}" do
      it "sends an email with a link with an invite code to register" do
        click_link "Invite users"

        expect {
          select profile_type.to_s.titleize, from: "Profile type"
          fill_in "Email", with: email_address
          click_button "Send invitation"
        }.to change {
          UserInvitation.sent.count
        }.from(0).to(1)

        mail = ActionMailer::Base.deliveries.last
        expect(mail).to be_present, "no mail was sent"

        invite_code = UserInvitation.last.admin_permission_token
        url = signup_url(invite_code: invite_code, host: ENV.fetch("HOST_DOMAIN"))
        expect(mail.body).to include("href=\"#{url}\"")
      end
    end
  end
end
