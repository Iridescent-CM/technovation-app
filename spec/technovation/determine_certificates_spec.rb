require "rails_helper"

RSpec.describe DetermineCertificates do
  context "for student" do
    it "awards participation" do
      student = FactoryBot.create(:student, :half_complete_submission)

      expect(DetermineCertificates.(student.account)).to contain_exactly(
        CertificateRecipient.new(:participation, student.account, team: student.team)
      )
    end

    it "awards completion" do
      student = FactoryBot.create(:student, :quarterfinalist)

      expect(DetermineCertificates.(student.account)).to contain_exactly(
        CertificateRecipient.new(:completion, student.account, team: student.team)
      )
    end

    it "awards semifinalist" do
      student = FactoryBot.create(:student, :semifinalist)

      expect(DetermineCertificates.(student.account)).to contain_exactly(
        CertificateRecipient.new(:semifinalist, student.account, team: student.team)
      )
    end

    it "awards nothing" do
      student = FactoryBot.create(:student)

      expect(DetermineCertificates.(student.account)).to be_empty

      student = FactoryBot.create(:student, :incomplete_submission)

      expect(DetermineCertificates.(student.account)).to be_empty
    end
  end

  context "for mentor" do
    it "awards mentor appreciation" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 1)

      expect(DetermineCertificates.(mentor.account)).to contain_exactly(
        CertificateRecipient.new(:mentor_appreciation, mentor.account, team: mentor.current_teams.first)
      )
    end

    it "awards many mentor appreciations" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 5)

      expected = mentor.current_teams.map do |team|
        CertificateRecipient.new(:mentor_appreciation, mentor.account, team: team)
      end
      expect(DetermineCertificates.(mentor.account)).to match_array(expected)
    end

    it "awards nothing" do
      mentor = FactoryBot.create(:mentor)

      expect(DetermineCertificates.(mentor.account)).to be_empty
    end
  end

  context "for mentor/judge" do
    it "awards mentor and judge certificates" do
      user = FactoryBot.create(:mentor, :has_judge_profile, number_of_teams: 1)
      5.times do
        FactoryBot.create(:score, :complete, judge_profile: user.account.judge_profile)
      end

      expect(DetermineCertificates.(user.account).map(&:certificate_type)).to contain_exactly(:mentor_appreciation, :certified_judge)
    end
  end

  context "for judge" do
    it "awards general judge" do
      judge = FactoryBot.create(:judge)

      1.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.(judge.account)).to contain_exactly(
        CertificateRecipient.new(:general_judge, judge.account)
      )
    end

    it "awards certified judge by count" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.(judge.account)).to contain_exactly(
        CertificateRecipient.new(:certified_judge, judge.account)
      )
    end

    it "awards head judge by count" do
      judge = FactoryBot.create(:judge)

      6.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.(judge.account)).to contain_exactly(
        CertificateRecipient.new(:head_judge, judge.account)
      )
    end

    it "awards head judge by event" do
      judge = FactoryBot.create(:judge, :attending_live_event)

      1.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.(judge.account)).to contain_exactly(
        CertificateRecipient.new(:head_judge, judge.account)
      )
    end

    it "awards judge advisor" do
      judge = FactoryBot.create(:judge)

      11.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.(judge.account)).to contain_exactly(
        CertificateRecipient.new(:judge_advisor, judge.account)
      )
    end

    it "awards nothing" do
      judge = FactoryBot.create(:judge)

      expect(DetermineCertificates.(judge.account)).to be_empty
    end
  end
end