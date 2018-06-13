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

    context "a team with a participation qualifying submission" do
      let(:submission) {
        double(
          :TeamSubmission,
          app_name: "Submission app name",
          :qualifies_for_participation? => true,
          :complete? => false,
          :semifinalist? => false
        )
      }

      let(:team) { double(:Team, name: "Team name", submission: submission) }

      it "needs a participation certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_participation_certificates: []
        )

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.needed_certificate_types).to eq(["participation"])
      end

      context "and already has a participation certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            current_participation_certificates: [double(:participation_certificate)]
          )

          recipient = CertificateRecipient.new(account, team)

          expect(recipient.needed_certificate_types).to be_empty
        end
      end
    end

    context "a team with a complete submission" do
      let(:submission) {
        double(
          :TeamSubmission,
          app_name: "Submission app name",
          :qualifies_for_participation? => false,
          :complete? => true,
          :quarterfinalist? => true,
          :semifinalist? => false
        )
      }

      let(:team) { double(:Team, name: "Team name", submission: submission) }

      it "needs a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_completion_certificates: []
        )

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.needed_certificate_types).to eq(["completion"])
      end

      context "and already has a completion certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            current_completion_certificates: [double(:completion_certificate)]
          )

          recipient = CertificateRecipient.new(account, team)

          expect(recipient.needed_certificate_types).to be_empty
        end
      end
    end

    context "a team with a semifinalist submission" do
      let(:submission) {
        double(
          :TeamSubmission,
          app_name: "Submission app name",
          :qualifies_for_participation? => false,
          :complete? => true,
          :quarterfinalist? => false,
          :semifinalist? => true
        )
      }

      let(:team) { double(:Team, name: "Team name", submission: submission) }

      it "needs a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_semifinalist_certificates: []
        )

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.needed_certificate_types).to eq(["semifinalist"])
      end

      context "and already has a completion certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            current_semifinalist_certificates: [double(:semifinalist_certificate)]
          )

          recipient = CertificateRecipient.new(account, team)

          expect(recipient.needed_certificate_types).to be_empty
        end
      end
    end
  end

  describe "#certificate_types" do
    context "a team with no submission" do
      it "gets no certificates" do
        account = double(:Account, id: 1, name: "My full name")
        team = double(:Team, name: "Team name", submission: NullTeamSubmission.new)

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.certificate_types).to be_empty
      end
    end
  end

  describe "#certificates" do
    context "a team with no submission" do
      it "has no certificates" do
        account = double(:Account, id: 1, name: "My full name")
        team = double(:Team, name: "Team name", submission: NullTeamSubmission.new)

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.certificates).to be_empty
      end
    end
  end
end