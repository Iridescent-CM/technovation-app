require "rails_helper"

RSpec.xdescribe "Judges sign up at special link", :js do
  it "visit the normal url" do
    visit judge_signup_path
    expect(current_path).to eq(root_path)
  end

  it "visit with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)
    expect(current_path).to eq(signup_path)
    expect(page).to have_text("I am over 18 years old and will judge submissions")
  end

  it "sign up" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)
    expect(current_path).to eq(signup_path)
    expect(page).to have_text("I am over 18 years old and will judge submissions")
  end

  it "encounter validation errors with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)
    expect(current_path).to eq(signup_path)
    expect(page).to have_text("I am over 18 years old and will judge submissions")
  end
end
