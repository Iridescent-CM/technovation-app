require "rails_helper"
require "fill_pdfs"

RSpec.describe DetermineCertificates do
  let(:season_with_templates) { instance_double(Season, year: 2020) }
  before { allow(Season).to receive(:current).and_return(season_with_templates) }

  context "for student" do
    it "awards participation" do
      student = FactoryBot.create(:student, :half_complete_submission)

      expect(DetermineCertificates.new(student.account).needed).to contain_exactly(
        CertificateRecipient.new(:participation, student.account, team: student.team)
      )
    end

    it "awards quarterfinalist" do
      student = FactoryBot.create(:student, :quarterfinalist)

      expect(DetermineCertificates.new(student.account).needed).to contain_exactly(
        CertificateRecipient.new(:quarterfinalist, student.account, team: student.team)
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

      FillPdfs.call(student.account)

      expect(DetermineCertificates.new(student.account).eligible_types).to contain_exactly("participation")
      expect(DetermineCertificates.new(student.account).needed).to be_empty
    end

    it "awards nothing if other student type certificate exists" do
      student = FactoryBot.create(:student, :half_complete_submission)

      FactoryBot.create(:certificate,
        account: student.account,
        team: student.team,
        cert_type: :quarterfinalist)

      expect(DetermineCertificates.new(student.account).eligible_types).to contain_exactly("participation")
      expect(DetermineCertificates.new(student.account).needed).to be_empty
    end
  end

  context "when the team's submission is more than 50% complete" do
    it "awards a mentor appreciation certificate" do
      mentor = FactoryBot.create(:mentor, :complete_submission, number_of_teams: 1)
      expect(DetermineCertificates.new(mentor.account).needed).to contain_exactly(
        CertificateRecipient.new(:mentor, mentor.account, team: mentor.current_teams.last)
      )
    end

    it "awards many mentor appreciations" do
      mentor = FactoryBot.create(:mentor, :complete_submission, number_of_teams: 5)
      team_submissions = mentor.current_teams.select do |team|
        team.submission.complete?
      end

      expected = team_submissions.map do |team|
        CertificateRecipient.new(:mentor, mentor.account, team: team)
      end
      expect(DetermineCertificates.new(mentor.account).needed).to match_array(expected)
    end
  end

  context "when the team's submission is less 50% complete" do
    it "does not award a mentor appreciation certificate" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 1)

      expect(DetermineCertificates.new(mentor.account).needed).to be_empty
    end

    it "does not award a mentor" do
      mentor = FactoryBot.create(:mentor)

      expect(DetermineCertificates.new(mentor.account).needed).to be_empty
    end

    it "does not award student certs for past student" do
      mentor = FactoryBot.create(:mentor, number_of_teams: 1)
      FactoryBot.create(:student, :quarterfinalist, account: mentor.account)

      expect(DetermineCertificates.new(mentor.account).eligible_types).to include("mentor")
      expect(DetermineCertificates.new(mentor.account).eligible_types).not_to include(*CertificateTypes::STUDENT_CERTIFICATE_TYPES.keys.map(&:to_s))
    end
  end

  context "for mentor/judge" do
    it "awards mentor and judge certificates" do
      user = FactoryBot.create(:mentor, :has_judge_profile, number_of_teams: 1)
      5.times do
        FactoryBot.create(:score, :complete, judge_profile: user.account.judge_profile)
      end

      expect(DetermineCertificates.new(user.account).eligible_types).to match_array(%w[mentor bronze_judge])
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

    it "counts dropped scores" do
      judge = FactoryBot.create(:judge)

      5.times do
        score = FactoryBot.create(:score, :complete, judge_profile: judge)
        score.drop_score!
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:bronze_judge, judge.account)
      )
    end

    it "ignores deleted scores" do
      judge = FactoryBot.create(:judge)

      5.times do
        score = FactoryBot.create(:score, :complete, judge_profile: judge)
        score.destroy
      end

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end

    it "awards certified judge by count" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:bronze_judge, judge.account)
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
        CertificateRecipient.new(:silver_judge, judge.account)
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
        CertificateRecipient.new(:silver_judge, judge.account)
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
        CertificateRecipient.new(:gold_judge, judge.account)
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
        CertificateRecipient.new(:bronze_judge, judge.account)
      )

      FactoryBot.create(:certificate,
        account: judge.account,
        cert_type: :silver_judge)

      expect(DetermineCertificates.new(judge.account).needed).to be_empty
    end
  end

  context "2026 judge certificate overrides" do
    let(:season_2026) { instance_double(Season, year: 2026) }

    before { allow(Season).to receive(:current).and_return(season_2026) }

    it "awards mapped gold judge with no scores" do
      account = FactoryBot.create(:account, id: 60314)
      judge = FactoryBot.create(:judge, account: account)

      expect(DetermineCertificates.new(account).needed).to contain_exactly(
        CertificateRecipient.new(:gold_judge, account)
      )
    end

    it "awards mapped silver judge even when score count would yield bronze" do
      account = FactoryBot.create(:account, id: 295714)
      judge = FactoryBot.create(:judge, account: account)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(account).eligible_types).to contain_exactly("silver_judge")
      expect(DetermineCertificates.new(account).needed).to contain_exactly(
        CertificateRecipient.new(:silver_judge, account)
      )
    end

    it "falls back to score-based logic for unmapped judges" do
      judge = FactoryBot.create(:judge)

      5.times do
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end

      expect(DetermineCertificates.new(judge.account).needed).to contain_exactly(
        CertificateRecipient.new(:bronze_judge, judge.account)
      )
    end

    it "does not award a certificate to a suspended mapped judge" do
      account = FactoryBot.create(:account, id: 60314)
      judge = FactoryBot.create(:judge, account: account)

      judge.suspend!

      expect(DetermineCertificates.new(account).needed).to be_empty
    end

    it "does not apply overrides outside the 2026 season" do
      allow(Season).to receive(:current).and_return(season_with_templates)

      account = FactoryBot.create(:account, id: 60314)
      FactoryBot.create(:judge, account: account)

      expect(DetermineCertificates.new(account).needed).to be_empty
    end
  end

  context "for ambassador" do
    def make_fully_onboarded_chapter_ambassador
      ambassador = FactoryBot.create(:ambassador)
      ambassador.update_column(:onboarded, true)
      chapter = ambassador.account.current_primary_chapter
      chapter.update_column(:onboarded, true)
      ambassador
    end

    def make_fully_onboarded_club_ambassador
      ambassador = FactoryBot.create(:club_ambassador)
      ambassador.update_column(:onboarded, true)
      club = ambassador.account.current_clubs.first
      club.update_column(:onboarded, true)
      ambassador
    end

    it "awards ambassador appreciation for a fully onboarded chapter ambassador" do
      ambassador = make_fully_onboarded_chapter_ambassador

      expect(DetermineCertificates.new(ambassador.account).needed).to contain_exactly(
        CertificateRecipient.new(:ambassador_appreciation, ambassador.account)
      )
    end

    it "awards ambassador appreciation for a fully onboarded club ambassador" do
      ambassador = make_fully_onboarded_club_ambassador

      expect(DetermineCertificates.new(ambassador.account).needed).to contain_exactly(
        CertificateRecipient.new(:ambassador_appreciation, ambassador.account)
      )
    end

    it "does not award when the ambassador profile is not onboarded" do
      ambassador = FactoryBot.create(:ambassador, training_completed_at: nil)
      ambassador.update_column(:onboarded, false)
      ambassador.account.current_primary_chapter.update_column(:onboarded, true)

      expect(DetermineCertificates.new(ambassador.account).needed).to be_empty
    end

    it "does not award when the chapter is not onboarded" do
      ambassador = make_fully_onboarded_chapter_ambassador
      ambassador.account.current_primary_chapter.update_column(:onboarded, false)

      expect(DetermineCertificates.new(ambassador.account).needed).to be_empty
    end

    it "does not award when the club is not onboarded" do
      ambassador = make_fully_onboarded_club_ambassador
      ambassador.account.current_clubs.first.update_column(:onboarded, false)

      expect(DetermineCertificates.new(ambassador.account).needed).to be_empty
    end

    it "does not award when not assigned to a chapter or club" do
      ambassador = make_fully_onboarded_chapter_ambassador
      ambassador.account.chapterable_assignments.destroy_all

      expect(DetermineCertificates.new(ambassador.account).needed).to be_empty
    end

    it "does not re-award if an ambassador certificate already exists" do
      ambassador = make_fully_onboarded_chapter_ambassador

      FactoryBot.create(:certificate,
        account: ambassador.account,
        cert_type: :ambassador_appreciation)

      expect(DetermineCertificates.new(ambassador.account).needed).to be_empty
    end
  end
end
