require "rails_helper"

RSpec.describe Division do
  describe ".for_account" do
    let(:account) { Account.new }

    before do
      allow(account).to receive(:age_by_cutoff).and_return(age_by_cuttoff_date)
    end

    context "when they are 8 years old" do
      let(:age_by_cuttoff_date) { 8 }

      it "returns the beginner division" do
        expect(Division.for_account(account)).to eq(Division.beginner)
      end
    end

    context "when they are 9 years old" do
      let(:age_by_cuttoff_date) { 9 }

      it "returns the beginner division" do
        expect(Division.for_account(account)).to eq(Division.beginner)
      end
    end

    context "when they are 10 years old" do
      let(:age_by_cuttoff_date) { 10 }

      it "returns the beginner division" do
        expect(Division.for_account(account)).to eq(Division.beginner)
      end
    end

    context "when they are 11 years old" do
      let(:age_by_cuttoff_date) { 11 }

      it "returns the beginner division" do
        expect(Division.for_account(account)).to eq(Division.beginner)
      end
    end

    context "when they are 12 years old" do
      let(:age_by_cuttoff_date) { 12 }

      it "returns the beginner division" do
        expect(Division.for_account(account)).to eq(Division.beginner)
      end
    end

    context "when they are 13 years old" do
      let(:age_by_cuttoff_date) { 13 }

      it "returns the junior division" do
        expect(Division.for_account(account)).to eq(Division.junior)
      end
    end

    context "when they are 14 years old" do
      let(:age_by_cuttoff_date) { 14 }

      it "returns the junior division" do
        expect(Division.for_account(account)).to eq(Division.junior)
      end
    end

    context "when they are 15 years old" do
      let(:age_by_cuttoff_date) { 15 }

      it "returns the junior division" do
        expect(Division.for_account(account)).to eq(Division.junior)
      end
    end

    context "when the aren't eligible (by age) for a beginner or junior division" do
      let(:age_by_cuttoff_date) { 18 }

      it "returns the senior division" do
        expect(Division.for_account(account)).to eq(Division.senior)
      end
    end
  end

  describe ".for_team" do
    let!(:team) { FactoryBot.create(:team) }
    let!(:beginner_student) { FactoryBot.create(:student, :beginner) }
    let(:junior_student) { FactoryBot.create(:student, :junior) }
    let(:senior_student) { FactoryBot.create(:student, :senior) }

    context "when a team has only beginner students" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, beginner_student)
      end

      it "returns the beginner division" do
        expect(Division.for_team(team)).to eq(Division.beginner)
      end
    end

    context "when a team has only junior students" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, junior_student)
      end

      it "returns the junior division" do
        expect(Division.for_team(team)).to eq(Division.junior)
      end
    end

    context "when a team has only senior students" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, senior_student)
      end

      it "returns the senior division" do
        expect(Division.for_team(team)).to eq(Division.senior)
      end
    end

    context "when a team has a beginner and junior student" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, [beginner_student, junior_student])
      end

      it "returns the junior division" do
        expect(Division.for_team(team)).to eq(Division.junior)
      end
    end

    context "when a team has a junior and senior student" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, [junior_student, senior_student])
      end

      it "returns the senior division" do
        expect(Division.for_team(team)).to eq(Division.senior)
      end
    end

    context "when a team has a beginner, junior and senior student" do
      before do
        team.students.delete_all

        TeamRosterManaging.add(team, [beginner_student, junior_student, senior_student])
      end

      it "returns the senior division" do
        expect(Division.for_team(team)).to eq(Division.senior)
      end
    end
  end

  describe ".for" do
    context "when an Account is provided" do
      let(:account) { Account.new }

      it "calls .for_account" do
        expect(Division).to receive(:for_account)

        Division.for(account)
      end
    end

    context "when a StudentProfile is provided" do
      let(:student_profile) { StudentProfile.new }

      it "calls .for_account" do
        expect(Division).to receive(:for_account)

        Division.for(student_profile)
      end
    end

    context "when a Team is provided" do
      let(:team) { Team.new }

      it "calls .for_team" do
        expect(Division).to receive(:for_team)

        Division.for(team)
      end
    end

    context "when an unsupported class is provided" do
      let(:unsupported_class) { MentorProfile.new }

      it "returns 'none assigned yet'" do
        expect(Division.for(unsupported_class)).to eq(Division.none_assigned_yet)
      end
    end

    context "when no class is provided" do
      let(:nil_class) { nil }

      it "returns 'none assigned yet'" do
        expect(Division.for(nil_class)).to eq(Division.none_assigned_yet)
      end
    end
  end
end
