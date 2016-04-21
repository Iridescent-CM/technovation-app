require 'rails_helper'

describe RankingController, type: :controller do
  describe 'assign_judges_to_regions' do
    subject { RankingController.assign_judges_to_regions }
    let(:whentooccur_event) { Faker::Date.forward(10) }
    let(:year) { whentooccur_event.year }
    let!(:region) { create(:region) }
    let(:event) { create(:event, region_id: region.id, whentooccur: whentooccur_event) }
    let!(:virtual_event) { create(:event, :virtual_event, whentooccur: whentooccur_event) }
    let!(:judge) { create(:user, :judge, judging_region_id: nil, event_id: event.id) }
    let!(:teams) { create_list(:team, 10, region_id: region.id, year: year) }

    before do
      allow(Setting).to receive(:year).and_return year
    end

    it 'assigns a region to judge' do 
      RankingController.assign_judges_to_regions
      judge.reload
      expect(judge.judging_region_id).to eq region.id 
    end
  end
end
