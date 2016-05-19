require 'rails_helper'

describe ScoresController, type: :controller do
  describe 'index' do

    it 'renders teams from the current year' do
      Season.open!

      current_team = create :team, name: "nice_name", year: Date.today.year
      last_year_team = create :team, year: Date.today.year - 1
      current_user = create :user
      current_user.team_requests.create!(team: current_team, approved: true)
      current_user.team_requests.create!(team: last_year_team, approved: true)

      sign_in(current_user)

      get :index

      expect(assigns[:scores].count).to eq 1
      expect(assigns[:scores].first.team).to eq "nice_name"
    end

    it 'renders scores related to teams from the current year' do
      Season.open!
      Quarterfinal.showScores!

      current_team = create :team, year: Date.today.year
      current_user = create :user
      rubric = create :rubric, team: current_team, stage: "quarterfinal"
      current_user.team_requests.create!(team: current_team, approved: true)

      sign_in(current_user)
      get :index

      expect(assigns[:scores].first.rubrics.count).to eq 1
    end
  end
end
