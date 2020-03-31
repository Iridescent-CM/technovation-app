require "rails_helper"
require "fill_pdfs"

RSpec.describe DetermineCertificates do
  context "for student" do
    it "awards participation" do
      student = FactoryBot.create(:student, :half_complete_submission)

      expect(DetermineCertificates.new(student.account).needed).to contain_exactly(
        CertificateRecipient.new(:participation, student.account, team: student.team)
      )
    end

    it "awards completion" do
      student = FactoryBot.create(:student, :quarterfinalist)

      expect(DetermineCertificates.new(student.account).needed).to contain_exactly(
        CertificateRecipient.new(:completion, student.account, team: student.team)
      )
    end

    it "awards semifinalist" do
      student = FactoryBot.create(:student, :semifinalist)

      expect(DetermineCertificates.new(student.account).needed).to contain_exactly(
        CertificateRecipient.new(:semifinalist, student.account, team: student.team)
      )
    end

    it "awards nothing" do
      student = FactoryBot.create(:student)

      expect(DetermineCertificates.new(student.account).needed).to be_empty

      student = FactoryBot.create(:student, :incomplete_submission)

      expect(DetermineCertificates.new(student.account).needed).to be_empty
    end

    it "awards nothing if equivalent certificate exists" do
      student = FactoryBot.create(:student, :half_complete_submission)

      FillPdfs.(student.account)

      expect(DetermineCertificates.new(student.account).eligible_types).to contain_exactly("participation")
      expect(DetermineCertificates.new(student.account).needed).to be_empty
    end

    it "awards nothing if other student type certificate exists" do
      student = FactoryBot.create(:student, :half_complete_submission)

      FactoryBot.create(:certificate,
        account: student.account,
        team: student.team,
        cert_type: :completion
      )

      expect(DetermineCertificates.new(student.account).eligible_types).to contain_exactly("participation")
      expect(DetermineCertificates.new(student.account).needed).to be_empty
    end
  end

  context "for mentor" do
    it "awards mentor appreciation" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 1)

      expect(DetermineCertificates.new(mentor.account).needed).to contain_exactly(
        CertificateRecipient.new(:mentor_appreciation, mentor.account, team: mentor.current_teams.first)
      )
    end

    it "awards many mentor appreciations" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 5)

      expected = mentor.current_teams.map do |team|
        CertificateRecipient.new(:mentor_appreciation, mentor.account, team: team)
      end
      expect(DetermineCertificates.new(mentor.account).needed).to match_array(expected)
    end

    it "awards nothing" do
      mentor = FactoryBot.create(:mentor)

      expect(DetermineCertificates.new(mentor.account).needed).to be_empty
    end

    it "does not award student certs for past student" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 1)
      FactoryBot.create(:student, :quarterfinalist, account: mentor.account)

      expect(DetermineCertificates.new(mentor.account).eligible_types).to include("mentor_appreciation")
      expect(DetermineCertificates.new(mentor.account).eligible_types).not_to include(*STUDENT_CERTIFICATE_TYPES.keys.map(&:to_s))
    end
  end

  context "for mentor/judge" do
    it "awards mentor and judge certificates" do
      user = FactoryBot.create(:mentor, :has_judge_profile, number_of_teams: 1)
      5.times do
        FactoryBot.create(:score, :complete, judge_profile: user.account.judge_profile)
      end

      expect(DetermineCertificates.new(user.account).eligible_types).to match_array(%w{mentor_appreciation certified_judge})
    end
  end

  context "for judge" do
    it "awards nothing for less than 4 scores" do
      judge = FactoryBot.create(:judge)

      4.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards certified judge by count" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:certified_judge, judge.account)
      )
    end

    it "does not award a certificate to a qualified judge who is suspended" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      judge.suspend!

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards head judge by count" do
      judge = FactoryBot.create(:judge)

      6.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:head_judge, judge.account)
      )
    end

    it "does not award a certificate to a qualified head judge who is suspended" do
      judge = FactoryBot.create(:judge)

      6.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      judge.suspend!

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards head judge by event" do
      judge = FactoryBot.create(:judge, :attending_live_event)

      1.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:head_judge, judge.account)
      )
    end

    it "does not award a certificate to a qualified head judge who is suspended that attended a live event" do
      judge = FactoryBot.create(:judge, :attending_live_event)

      1.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      judge.suspend!

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards judge advisor" do
      judge = FactoryBot.create(:judge)

      11.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:judge_advisor, judge.account)
      )
    end

    it "does not award a certificate to a qualified judge advisor who is suspended" do
      judge = FactoryBot.create(:judge)

      11.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      judge.suspend!

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards nothing" do
      judge = FactoryBot.create(:judge)

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards nothing if judge type certificate already present" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:certified_judge, judge.account)
      )

      FactoryBot.create(:certificate,
        account: judge.account,
        cert_type: :head_judge
      )

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end
  end
end
