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
          current_completed_scores: [],
          events: [],
        )

        account = double(
          :Account,
          id: 1,
          name: "My full name",
          judge_profile: judge_profile,
          mentor_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
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
          override_certificate_type: nil,
        )
        team = double(:Team, id: 2, name: "Team name", submission: NullTeamSubmission.new)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "needs a participation certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_participation_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
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
            current_participation_certificates: [double(:participation_certificate)],
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
            override_certificate_type: nil,
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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "needs a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_completion_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
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
            current_completion_certificates: [double(:completion_certificate)],
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
            override_certificate_type: nil,
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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "needs a completion certificate" do
        student_profile = double(:StudentProfile, :present? => true)

        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_semifinalist_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: student_profile,
          override_certificate_type: nil,
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
            current_semifinalist_certificates: [double(:semifinalist_certificate)],
            mentor_profile: NullProfile.new,
            judge_profile: NullProfile.new,
            student_profile: NullProfile.new,
            override_certificate_type: nil,
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
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
        )

        team = double(:Team, id: 2, name: "Team name", submission: NullTeamSubmission.new)

        recipient = CertificateRecipient.new(account, team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "gets a participation certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_participation_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
        )

        recipient = CertificateRecipient.new(account, team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "gets a completion certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_completion_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: NullProfile.new,
          override_certificate_type: nil,
        )

        recipient = CertificateRecipient.new(account, team)

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

      let(:team) { double(:Team, id: 2, name: "Team name", submission: submission) }

      it "gets a semifinalist certificate" do
        account = double(
          :Account,
          id: 1,
          name: "My full name",
          current_semifinalist_certificates: [],
          mentor_profile: NullProfile.new,
          judge_profile: NullProfile.new,
          student_profile: double(:StudentProfile, :present? => true),
          override_certificate_type: nil,
        )

        recipient = CertificateRecipient.new(account, team)

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
          override_certificate_type: nil,
        )
        team = double(:Team, id: 2, name: "Team name", submission: NullTeamSubmission.new)

        recipient = CertificateRecipient.new(account, team)

        expect(recipient.certificates).to be_empty
      end
    end
  end
end