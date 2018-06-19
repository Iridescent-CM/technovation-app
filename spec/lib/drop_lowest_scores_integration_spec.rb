require "rails_helper"

RSpec.describe DropLowestScores do
  it "preserves the lowest score's judge's original certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 11)

    submission = judge.scores.sample.team_submission

    DropLowestScores.(submission)

    recipient = CertificateRecipient.new(judge.account.reload)

    expect(recipient.certificate_type).to eq(Account.override_certificate_types['judge_advisor'])
    expect(judge.override_certificate_type).to eq(Account.override_certificate_types['judge_advisor'])
  end

  it "ignores duplicate runs of the same submission" do
    SeasonToggles.set_judging_round(:sf)

    submission = FactoryBot.create(:submission, :complete, number_of_scores: 2)

    expect {
      DropLowestScores.(submission)
    }.to change {
      submission.semifinals_complete_submission_scores.count
    }.from(2).to(1)

    expect(DropLowestScores.(submission)).to be false

    expect {
      DropLowestScores.(submission)
    }.not_to change {
      submission.semifinals_complete_submission_scores.count
    }
  end
end