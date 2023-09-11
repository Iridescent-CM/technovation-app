require "rails_helper"

RSpec.describe "Registration invites", :js do
  let(:admin) { FactoryBot.create(:admin) }

  %i[student mentor judge].each do |profile_type|
    context "as an admin" do
      before do
        sign_in(admin)
      end

      context "when sending an invite to a #{profile_type}" do
        it "sends an email with a link with an invite code to register" do
          email = "#{profile_type}@example.com"

          click_link "Invite users"

          expect {
            select profile_type.to_s.titleize, from: "Profile type"
            fill_in "Email", with: email
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
end
