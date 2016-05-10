require 'rails_helper'

describe TeamsController, type: :controller do
  describe 'GET #edit' do
    it 'calls open_for_signup_by_region' do
      region = create(:region)
      team = create(:team, region: region)

      sign_in

      expect(Event).to receive(:open_for_signup_by_region).with(region.id)

      get :edit_submission, id: team.slug
    end
  end

  describe "GET #index" do
    it "shows current teams without a previous_years param" do
      Season.open!(Date.today.year)
      team = FactoryGirl.create(:team, year: Setting.year)
      FactoryGirl.create(:team, year: Date.today.year - 1)

      get :index

      expect(assigns[:teams].to_a).to eq([team])
    end
  end
end
