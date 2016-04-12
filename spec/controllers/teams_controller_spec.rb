require 'rails_helper'

describe TeamsController, type: :controller do
  describe '.edit_submission' do
    subject { sign_in; get :edit_submission, id: 1 } 

    let(:region_id) { Faker::Number.number(5).to_i }
    let(:region) { build(:region, id: region_id) }
    let(:team) { build(:team, region: region) }

    before do
      allow(Team).to receive_message_chain(:friendly, :find).and_return(team)
    end

    it 'calls open_for_signup_by_region' do
      expect(Event).to receive(:open_for_signup_by_region).with(region_id)
      subject
    end
  end
end
