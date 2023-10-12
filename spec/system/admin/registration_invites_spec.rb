require "rails_helper"

RSpec.describe "Registration invites", :js do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in(admin)
  end

  [
    {
      invite_profile_type: "student",
      friendly_profile_type: "student",
      select_option: "Student (Jr/Sr Division)"
    },
    {
      invite_profile_type: "parent_student",
      friendly_profile_type: "parent",
      select_option: "Parent (Beginner Division)"
    },
    {
      invite_profile_type: "mentor",
      friendly_profile_type: "mentor",
      select_option: "Mentor"
    },
    {
      invite_profile_type: "judge",
      friendly_profile_type: "juge",
      select_option: "Judge"
    },
    {
      invite_profile_type: "chapter_ambassador",
      friendly_profile_type: "chapter ambassador",
      select_option: "Chapter Ambassador"
    }
  ].each do |item|
    let(:name) { "Devin #{item[:friendly_profile_type]}" }
    let(:email_address) { "#{item[:invite_profile_type]}@example.com" }

    context "when an admin invites a #{item[:friendly_profile_type]}" do
      it "sends an email with a link with an invite code to register" do
        click_link "Registration Invites"

        expect {
          select item[:select_option], from: "Profile type"
          fill_in "Name", with: name
          fill_in "Email", with: email_address
          click_button "Send invitation"
        }.to change {
          UserInvitation.sent.count
        }.from(0).to(1)

        mail = ActionMailer::Base.deliveries.last
        expect(mail).to be_present, "no mail was sent"

        invite_code = UserInvitation.last.admin_permission_token
        url = signup_url(invite_code: invite_code, host: ENV.fetch("HOST_DOMAIN"))
        expect(mail.body).to include("Hi #{name}")
        expect(mail.body).to include("href=\"#{url}\"")
      end
    end
  end

  context "when an admin sends an invite" do
    it "sets the 'invited by account' to the admin who sent the invite" do
      click_link "Registration Invites"

      select "Judge", from: "Profile type"
      fill_in "Email", with: "jugdge_invite@example.com"
      click_button "Send invitation"

      expect(UserInvitation.last.invited_by).to eq(admin.account)
    end
  end
end
