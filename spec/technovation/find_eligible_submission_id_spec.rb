require "rails_helper"

RSpec.describe FindEligibleSubmissionId do
  context "judge without team" do
    it "returns submission id" do
      judge = FactoryGirl.create(:judge)
      team = FactoryGirl.create(:team)
      sub = TeamSubmission.create!({
        integrity_affirmed: true,
        team: team,
      })

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end
  end

  context "judge with team" do
    it "returns submission id from team in different region" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team, creator_in: "Chicago", division: Division.senior)
      judge.teams << judges_team

      different_region_team = FactoryGirl.create(:team, creator_in: "Los Angeles", division: Division.senior)
      sub = TeamSubmission.create!({
        integrity_affirmed: true,
        team: different_region_team,
      })

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "returns submission id from team in different division" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team, creator_in: "Chicago", division: Division.senior)
      judge.teams << judges_team

      different_division_team = FactoryGirl.create(:team, creator_in: "Chicago", division: Division.junior)
      sub = TeamSubmission.create!({
        integrity_affirmed: true,
        team: different_division_team,
      })

      expect(FindEligibleSubmissionId.(judge)).to eq(sub.id)
    end

    it "does not return submission id from judge's team" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team)
      judge.teams << judges_team
      sub = TeamSubmission.create!({
        integrity_affirmed: true,
        team: judges_team,
      })

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end

    it "does not return submission id from team in same region and division" do
      judge = FactoryGirl.create(:judge)
      judge.account.mentor_profile = FactoryGirl.create(:mentor)

      judges_team = FactoryGirl.create(:team)
      judge.teams << judges_team

      same_region_division_team = FactoryGirl.create(:team)
      sub = TeamSubmission.create!({
        integrity_affirmed: true,
        team: same_region_division_team,
      })

      expect(FindEligibleSubmissionId.(judge)).to be_nil
    end
  end
end
