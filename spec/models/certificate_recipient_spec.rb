require "spec_helper"
require "./app/models/certificate_recipient"
require "./app/null_objects/null_profile"
require "./app/null_objects/null_team_submission"

RSpec.describe CertificateRecipient do
  describe "#needed_certificate_types" do
    context "for a judge with 0 completed current scores" do
      it "needs no certificates" do
        judge_profile = double(
          :JudgeProfile,
          completed_scores: double(:completed_scores, by_season: []),
          events: [],
        )

        account = double(
          :Account,
          id: 1,
          name: "My full name",
          judge_profile: judge_profile,
          mentor_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        recipient = CertificateRecipient.new(account)

        expect(recipient.needed_certificate_types).to be_empty
      end
    end

    context "a team with no submission" do
      it "needs no certificates" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          judge_profile: NullProfile.new,
          mentor_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )
        team = double(
          :Team,
          id: 2,
          name: "Team name",
          submission: NullTeamSubmission.new,
          season: 2018,
        )

        recipient = CertificateRecipient.new(account, team: team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "needs a participation certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          participation_certificates: double(:participation_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.needed_certificate_types).to eq(["participation"])
      end

      context "and already has a participation certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            participation_certificates: double(:participation_certs, by_season: [
              double(:participation_certificate)
            ]),
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
          )

          recipient = CertificateRecipient.new(account, team: team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "needs a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          completion_certificates: double(:completion_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.needed_certificate_types).to eq(["completion"])
      end

      context "and already has a completion certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            completion_certificates: double(:completion_certs, by_season: [
              double(:completion_certificate),
            ]),
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
          )

          recipient = CertificateRecipient.new(account, team: team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "needs a completion certificate" do
        student_profile = double(:StudentProfile, :present? => true)

        account = double(
          :Account,
          id: 1,
          name: "My full name",
          semifinalist_certificates: double(:semi_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: student_profile,
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.needed_certificate_types).to eq(["semifinalist"])
      end

      context "and already has a completion certificate" do
        it "needs no certificates" do
          account = double(
            :Account,
            id: 1,
            name: "My full name",
            semifinalist_certificates: double(:semi_certs, by_season: [
              double(:semifinalist_certificate),
            ]),
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
          )

          recipient = CertificateRecipient.new(account, team: team)

          expect(recipient.needed_certificate_types).to be_empty
        end
      end
    end
  end

  describe "#certificate_types" do
    context "a team with no submission" do
      it "gets no certificates" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        team = double(:Team, id: 2, name: "Team name", submission: NullTeamSubmission.new, season: 2018)

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.certificate_types).to be_empty
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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "gets a participation certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          participation_certificates: double(:participation_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.certificate_types).to eq(["participation"])
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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "gets a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          completion_certificates: double(:completion_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.certificate_types).to eq(["completion"])
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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission, season: 2018) }

      it "gets a semifinalist certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          semifinalist_certificates: double(:semi_certs, by_season: []),
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: double(:StudentProfile, :present? => true),
        )

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.certificate_types).to eq(["semifinalist"])
      end
    end
  end

  describe "#certificates" do
    context "a team with no submission" do
      it "has no certificates" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
        )
        team = double(:Team, id: 2, name: "Team name", submission: NullTeamSubmission.new, season: 2018)

        recipient = CertificateRecipient.new(account, team: team)

        expect(recipient.certificates).to be_empty
      end
    end
  end
end