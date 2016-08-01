require "spec_helper"
require "./app/technovation/register_student"

RSpec.describe RegisterStudent do
  it "accepts team member invites" do
    account = double(:account, email: "email@email.com", save: true)
    controller = double(:controller)
    invite = double(:invite)
    mailer = double(:mailer).as_null_object

    expect(controller).to receive(:get_cookie).with(:team_invite_token) { "token" }
    expect(RegisterStudent).to receive(:invite) { invite }
    expect(RegisterStudent).to receive(:mailer) { mailer }
    expect(invite).to receive(:accept!).with("token", "email@email.com")
    RegisterStudent.(account, controller)
  end
end
