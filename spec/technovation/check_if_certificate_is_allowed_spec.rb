require "rails_helper"

RSpec.describe CheckIfCertificateIsAllowed do
  let(:student) { FactoryGirl.create(:student) }
  let(:team) { FactoryGirl.create(:team) }

  def student_on_team
    TeamRosterManaging.add(team, student)
    student
  end

  it "returns false for nil user" do
    expect(CheckIfCertificateIsAllowed.(nil, :completion)).to be false
  end

  context "student" do
    [nil, "", " ", "no-such-type"].each do |type|
      it "returns false for #{type} cert_type" do
        expect(CheckIfCertificateIsAllowed.(student, type)).to be false
      end
    end

    context "completion" do
      it "returns false if the student is not on a team" do
        expect(CheckIfCertificateIsAllowed.(student, :completion)).to be false
      end

      it "returns false if the student's team did not submit" do
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :completion)
        ).to be false
      end

      it "returns true if the student's team's submission is present" do
        team.team_submissions.create!(integrity_affirmed: true)
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :completion)
        ).to be true
      end
    end

    context "regional grand prize" do
      it "returns false if the student is not on a team" do
        expect(CheckIfCertificateIsAllowed.(student, :rpe_winner)).to be false
      end

      it "returns false if the student's team did not submit" do
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :rpe_winner)
        ).to be false
      end

      it "returns false if the student's team submission is not a semifinalist" do
        team.team_submissions.create!(
          integrity_affirmed: true,
          contest_rank: :quarterfinalist
        )
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :rpe_winner)
        ).to be false
      end

      it "returns false if the student's team was not at an official RPE" do
        team.team_submissions.create!(
          integrity_affirmed: true,
          contest_rank: :quarterfinalist
        )
        rpe = FactoryGirl.create(:rpe, unofficial: true)
        rpe.teams << team
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :rpe_winner)
        ).to be false
      end

      it "returns false if team attended an official RPE, isn't a semifinalist" do
        team.team_submissions.create!(
          integrity_affirmed: true,
          contest_rank: :quarterfinalist
        )
        rpe = FactoryGirl.create(:rpe, unofficial: false)
        rpe.teams << team
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :rpe_winner)
        ).to be false
      end

      it 'returns true if the team attended official RPE, is a semifinalist' do
        team.team_submissions.create!(
          integrity_affirmed: true,
          contest_rank: :semifinalist
        )
        rpe = FactoryGirl.create(:rpe, unofficial: false)
        rpe.teams << team
        expect(
          CheckIfCertificateIsAllowed.(student_on_team, :rpe_winner)
        ).to be true
      end
    end
  end

  context "mentor" do
    let(:mentor) { FactoryGirl.create(:mentor) }

    [nil, "", " ", "no-such-type"].each do |type|
      it "returns false for #{type} cert_type" do
        expect(CheckIfCertificateIsAllowed.(mentor, type)).to be false
      end
    end

    context "appreciation" do
      it "returns false if the mentor is not on a team" do
        expect(CheckIfCertificateIsAllowed.(mentor, :appreciation)).to be false
      end

      it "returns true if the mentor is on a team" do
        TeamRosterManaging.add(team, mentor)
        team.students.destroy_all
        expect(CheckIfCertificateIsAllowed.(mentor, :appreciation)).to be true
      end
    end
  end
end
