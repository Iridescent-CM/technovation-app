require "spec_helper"
require "./app/models/certificate_recipient"
require "./app/null_objects/null_team_submission"

RSpec.describe CertificateRecipient do
  describe "#needed_certificate_types" do
    context "a team with no submission" do
      it "needs no certificates" do
        account = double(:Account, id: 1, name: "My full name")
        team = double(:Team, name: "Team name", submission: NullTeamSubmission.new)

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.needed_certificate_types).to be_empty
      end
    end
  end

  describe "#certificate_types"
  describe "#certificates"
end