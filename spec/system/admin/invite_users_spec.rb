require "rails_helper"

RSpec.describe "Admins invite users to signup", :js do
  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in(admin) }

  %i{judge regional_ambassador mentor student}.each do |scope|
    it "Inviting a user with profile type #{scope}" do
      email = "#{scope}@example.com"

      click_link "Invite users"

      expect {
        select scope.to_s.titleize, from: "Profile type"
        fill_in "Email", with: email
        click_button "Send invitation"
      }.to change {
        UserInvitation.sent.count
      }.from(0).to(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_present, "no mail was sent"

      token = UserInvitation.last.admin_permission_token
      visit send("#{scope}_signup_path", admin_permission_token: token)

      expect(mail.to).to eq([email])

      url = send(
        "#{scope}_signup_url",
        admin_permission_token: token,
        host: ENV.fetch("HOST_DOMAIN"),
      )
      expect(mail.body).to include("href=\"#{url}\"")

      visit(send("#{scope}_signup_path", admin_permission_token: token))

      expect(current_path).to eq(send("#{scope}_signup_path"))
    end

    it "#{scope} signs up, registering their invite" do
      email = "#{scope}@example.com"
      UserInvitation.create!(
        profile_type: scope,
        email: email,
      )

      token = UserInvitation.last.admin_permission_token
      visit send("#{scope}_signup_path", admin_permission_token: token)

      birthdate = case scope
                  when :student
                    Date.today - 15.years
                  else
                    Date.today - 25.years
                  end

      fill_in "First name", with: "Pamela"
      fill_in "Last name", with: "Beasley"

      select_chosen_date birthdate, from: "Date of birth"

      case scope
      when :student
        fill_in "School name", with: "John Hughes High."
      when :mentor
        select_gender(:random)
        fill_in_vue_select "School or company name", with: "John Hughes High."
        fill_in "Job title", with: "Janitor / Man of the Year"
        select "Parent", from: "I am a..."
      when :judge
        select_gender(:random)
        fill_in_vue_select "Company name", with: "John Hughes High."
        fill_in "Job title", with: "Janitor / Man of the Year"
      when :regional_ambassador
        select_gender(:random)
        fill_in_vue_select "Organization/company name", with: "John Hughes High."
        fill_in "Job title", with: "Janitor / Man of the Year"
        fill_in "Tell us about yourself",
          with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."
      end

      fill_in "Create a password", with: "my-secret-password"

      click_button "Create Your Account"

      expect(current_path).to eq(send("#{scope}_dashboard_path"))

      invite = UserInvitation.last
      expect(invite).to be_registered
      expect(invite.account).to eq(Account.last)

      if scope == :regional_ambassador
        expect(RegionalAmbassadorProfile.last).to be_approved
      end
    end

    it "#{scope} uses the invite link a second time" do
      email = "#{scope}@example.com"

      invite = UserInvitation.create!(
        profile_type: scope,
        email: email,
      )

      profile = FactoryBot.create(
        scope,
        account: FactoryBot.create(:account, email: email)
      )

      invite.update(
        account: profile.account,
        status: :registered,
      )

      token = invite.admin_permission_token

      visit send(
        "#{scope}_signup_path",
        admin_permission_token: token,
      )

      expect(current_path).to eq(send("#{scope}_dashboard_path"))
    end
  end

  it "invite an RA who has an existing mentor account" do
    email = "ra@example.com"
    mentor = FactoryBot.create(
      :mentor,
      :onboarded,
      account: FactoryBot.create(:account, email: email)
    )
    expect(mentor.account.reload.email).to eq(email)

    UserInvitation.create!(
      profile_type: "regional_ambassador",
      email: email,
    )

    token = UserInvitation.last.admin_permission_token

    visit regional_ambassador_signup_path(admin_permission_token: token)

    birthdate = Date.today - 25.years

    fill_in "First name", with: "Pamela"
    fill_in "Last name", with: "Beasley"

    select_chosen_date birthdate, from: "Date of birth"

    select_gender(:random)

    fill_in_vue_select "Organization/company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"
    fill_in "Tell us about yourself",
      with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

    fill_in "Create a password", with: "my-secret-password"

    click_button "Create Your Account"

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    invite = UserInvitation.last
    expect(invite.account.mentor_profile).to eq(mentor)
  end

  it "invite an RA who has an existing judge account" do
    email = "ra@example.com"
    judge = FactoryBot.create(
      :judge,
      account: FactoryBot.create(:account, email: email)
    )
    expect(judge.account.reload.email).to eq(email)

    UserInvitation.create!(
      profile_type: "regional_ambassador",
      email: email,
    )

    token = UserInvitation.last.admin_permission_token

    visit regional_ambassador_signup_path(
      admin_permission_token: token,
      host: Capybara.app_host
    )

    birthdate = Date.today - 25.years

    fill_in "First name", with: "Pamela"
    fill_in "Last name", with: "Beasley"

    select_chosen_date birthdate, from: "Date of birth"

    select_gender(:random)

    fill_in_vue_select "Organization/company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"
    fill_in "Tell us about yourself",
      with: "Lorem ipsum dolor sit amet, " +
            "consectetur adipiscing elit. " +
            "Phasellus ut diam vel felis fringilla amet."

    fill_in "Create a password", with: "my-secret-password"

    click_button "Create Your Account"

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    invite = UserInvitation.last
    expect(invite.account.reload.judge_profile).to eq(judge)
  end
end
