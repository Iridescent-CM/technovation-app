require "rails_helper"

RSpec.describe FindEligibleSubmissionId, vcr: { record: :all }, no_es_stub: true do
  context "judge who is also a mentor" do

    subject(:judge) {
      team = FactoryGirl.create(:team, division: Division.senior, creator_in: "Chicago")
      mentor_profile = FactoryGirl.create(:mentor) 
      mentor_profile.teams << team
      judge_profile = FactoryGirl.create(:judge)
      mentor_profile.account.judge_profile = judge_profile
      judge_profile
    }

    before do 
      JudgeProfile.__elasticsearch__.create_index! force:true
      TeamSubmission.__elasticsearch__.create_index! force:true
      judge.__elasticsearch__.index_document refresh: true
    end

    it "does return team in same region, different division" do
      team = FactoryGirl.create(:team, division: Division.junior)
      submission = FactoryGirl.create(:team_submission, team: team)

      submission.__elasticsearch__.index_document refresh: true

      id = FindEligibleSubmissionId.(judge)
      expect(id).not_to be_nil
    end

    it "does return team in different region, same division" do
      team = FactoryGirl.create(:team, division: Division.senior, creator_in: "Los Angeles")
      submission = FactoryGirl.create(:team_submission, team: team)

      submission.__elasticsearch__.index_document refresh: true

      id = FindEligibleSubmissionId.(judge)
      expect(id).not_to be_nil
    end

    it "does not return team in same region, same division" do
      team = FactoryGirl.create(:team, division: Division.senior, creator_in: "Chicago")
      submission = FactoryGirl.create(:team_submission, team: team)

      submission.__elasticsearch__.index_document refresh: true

      id = FindEligibleSubmissionId.(judge)
      expect(id).to be_nil
    end

  end
end
