require "rails_helper"

RSpec.feature "Judges sign up at special link" do
  scenario "visit the normal url" do
    visit judge_signup_path
    expect(current_path).to eq(root_path)
  end

  scenario "visit with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    within("form#new_judge_profile") do
      expect(page).to have_css("input[type=email]")
      expect(page).to have_css("input[type=password]")
    end
  end
end
