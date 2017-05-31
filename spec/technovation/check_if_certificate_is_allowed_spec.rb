require "rails_helper"

RSpec.describe CheckIfCertificateIsAllowed do
  let(:student) { FactoryGirl.create(:student) }
  let(:team) { FactoryGirl.create(:team) }

  it "returns false for nil user" do
    expect(CheckIfCertificateIsAllowed.(nil, :completion)).to be false
  end

  [nil, "", " ", "no-such-type"].each do |type|
    it "returns false for #{type} cert_type" do
      expect(CheckIfCertificateIsAllowed.(student, type)).to be false
    end
  end

  context "student" do
    context "completion" do
      it "returns false if the student is not on a team" do
        expect(CheckIfCertificateIsAllowed.(student, :completion)).to be false
      end

      it "returns false if the student's team did not submit" do
        team.add_student(student)
        expect(CheckIfCertificateIsAllowed.(student, :completion)).to be false
      end

      it "returns false if the student's team's submission is not complete" do
        team.add_student(student)
        team.team_submissions.create!(integrity_affirmed: true)
        expect(CheckIfCertificateIsAllowed.(student, :completion)).to be false
      end

      it "returns true if the student's team's submission is complete" do
        team.add_student(student)
        FactoryGirl.create(:team_submission, :complete, team: team)
        expect(CheckIfCertificateIsAllowed.(student, :completion)).to be true
      end
    end
  end
end
