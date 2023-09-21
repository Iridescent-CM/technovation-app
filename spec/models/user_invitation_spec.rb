require "rails_helper"

RSpec.describe UserInvitation do
  it "validates the email against an existing user" do
    FactoryBot.create(
      :student,
      account: FactoryBot.create(:account, email: " heLLo@world.com ")
    )

    invite = UserInvitation.new(
      profile_type: :student,
      email: "  Hello@WORLD.com     ",
    )

    expect(invite).not_to be_valid
    expect(invite.errors[:email]).to include(
      "An account already exists with that email"
    )
  end

  it "validates the email against an existing chapter ambassador" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)
    chapter_ambassador.account.create_mentor_profile!(
      FactoryBot.attributes_for(:mentor)
        .merge({mentor_type_ids: [MentorType.first.id]})
    )

    invite = UserInvitation.new(
      profile_type: :chapter_ambassador,
      email: chapter_ambassador.email
    )

    expect(invite).not_to be_valid
    expect(invite.errors[:email]).to include(
      "An account already exists with that email"
    )
  end

  %i{student mentor judge}.each do |type|
    it "validates email against existing mentor if the type is #{type}" do
      mentor = FactoryBot.create(:mentor, :onboarded)

      invite = UserInvitation.new(
        profile_type: type,
        email: mentor.email
      )

      expect(invite).not_to be_valid
      expect(invite.errors[:email]).to include(
        "An account already exists with that email"
      )
    end
  end

  it "allows an existing mentor to be moved for a chapter ambassador" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    invite = UserInvitation.new(
      profile_type: :chapter_ambassador,
      email: mentor.email,
    )

    expect(invite).to be_valid
  end

  it "allows an existing judge to be moved for a chapter ambassador" do
    judge = FactoryBot.create(:judge)

    invite = UserInvitation.new(
      profile_type: :chapter_ambassador,
      email: judge.email,
    )

    expect(invite).to be_valid
  end

  it "updates judges assigned to events after signing up" do
    event = FactoryBot.create(:event)

    invite = UserInvitation.create!(
      profile_type: :judge,
      email: "judge@judge.com",
      event_ids: [event.id],
    )

    judge = FactoryBot.create(
      :judge,
      account: FactoryBot.create(:account, email: "judge@judge.com")
    )

    UpdateRegistrationInviteJob.perform_now(invite_code: invite.admin_permission_token, account_id: judge.account.id)

    expect(invite.reload).to be_registered
    expect(invite.account).to eq(judge.account)
    expect(event.reload.judge_list).to eq([judge])
  end

  describe "#pending?" do
    let(:invite) do
      UserInvitation.new(
        profile_type: :student,
        status: invite_status
      )
    end

    context "when the invite has a status of 'sent'" do
      let(:invite_status) { "sent" }

      it "is pending" do
        expect(invite.pending?).to eq(true)
      end
    end

    context "when the invite has a status of 'opened'" do
      let(:invite_status) { "opened" }

      it "is pending" do
        expect(invite.pending?).to eq(true)
      end
    end

    context "when the invite has a status of 'registered'" do
      let(:invite_status) { "registered" }

      it "is is not pending" do
        expect(invite.pending?).to eq(false)
      end
    end
  end
end
