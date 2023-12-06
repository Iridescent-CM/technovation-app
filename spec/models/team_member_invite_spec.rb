require "rails_helper"

RSpec.describe TeamMemberInvite do
  describe ".students_sending_invites_enabled?" do
    let(:students_sending_invites_enabled) { TeamMemberInvite.students_sending_invites_enabled?(important_dates: important_dates) }
    let(:important_dates) {
      class_double("ImportantDates",
        official_start_of_season: official_start_of_season,
        submission_deadline: submission_deadline)
    }

    let(:official_start_of_season) { Date.parse("2023-01-01") }
    let(:submission_deadline) { Date.parse("2023-10-15") }

    context "when today's date is between the official start of season and the submission deadline" do
      before do
        Timecop.freeze(Date.parse("2023-10-12"))
      end

      after do
        Timecop.return
      end

      it "is returns true" do
        expect(students_sending_invites_enabled).to eq(true)
      end
    end

    context "when today's date is NOT between the official start of season and the submission deadline" do
      before do
        Timecop.freeze(Date.parse("2024-10-17"))
      end

      after do
        Timecop.return
      end

      it "is returns false" do
        expect(students_sending_invites_enabled).to eq(false)
      end
    end
  end

  it "prevents duplicate pending invites for the same team" do
    original_invite = FactoryBot.create(:team_member_invite)

    invite = FactoryBot.build(:team_member_invite,
                               team_id: original_invite.team_id,
                               invitee_email: original_invite.invitee_email)

    expect(invite).not_to be_valid
    expect(invite.errors[:invitee_email]).to eq(["has already been invited by your team."])
  end

  it "allows another pending invite for previously accepted invite" do
    original_invite = FactoryBot.create(:team_member_invite, status: :accepted)

    invite = FactoryBot.build(:team_member_invite,
                               team_id: original_invite.team_id,
                               invitee_email: original_invite.invitee_email)

    expect(invite).to be_valid
  end

  it "declines other pending invites on acceptance" do
    invite1 = FactoryBot.create(:team_member_invite)
    invite2 = FactoryBot.create(:team_member_invite, invitee_email: invite1.invitee_email)

    invite1.accepted!
    expect(invite2.reload).to be_declined
  end
end
