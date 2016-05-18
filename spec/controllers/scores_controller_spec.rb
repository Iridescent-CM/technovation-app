require 'rails_helper'

describe ScoresController, type: :controller do
  describe 'index' do
    let(:student) { FactoryGirl.build(:user, role: :student) }

    it 'renders scores related to teams from the current year' do
      current_user_teams = double
      allow(student).to receive(:teams).and_return current_user_teams
      expect(current_user_teams).to receive(:current)

      sign_in(student)
      get :index
      expect(assigns[:scores]).to_not be_nil
    end
  end
end
