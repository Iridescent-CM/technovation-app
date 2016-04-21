require 'rails_helper'

describe RankingController, type: :controller do
  describe 'assign_judges_to_regions' do
    subject { RankingController.assign_judges_to_regions }
    let(:whentooccur_event) { Faker::Date.forward(10) }
    let(:year) { whentooccur_event.year }
    let!(:region) { create(:region, id: nil) }
    let(:in_person_event) do
      create(:event, region_id: region.id, whentooccur: whentooccur_event)
    end
    let!(:virtual_event) { create(:event, :virtual_event, whentooccur: whentooccur_event) }
    let(:judge_event) {  in_person_event }
    let(:judge_country) { 'CH' }
    let!(:judge) do
      create(
        :user,
        :judge,
        judging_region_id: nil,
        event_id: judge_event.id,
        home_country: judge_country
      )
    end

    let!(:teams) { create_list(:team, 10, region_id: region.id, year: year) }
    let(:ms_division) { 0 }
    let(:hs_division) { 1 }

    let(:ms_south_american_region) do
      create(:region, region_name: "MS - South America", division: ms_division) 
    end
    
    let(:hs_south_american_region) do
      create(:region, region_name: "HS - South America", division: hs_division) 
    end
    
    let!(:south_american_region_ids) do 
      [
        ms_south_american_region.id,
        hs_south_american_region.id
      ]
    end
    
    let(:brazilian_events) do
      south_american_region_ids.map do |region_id|
        create(:event, region_id: region_id, whentooccur: whentooccur_event )
      end
    end
    
    let(:brazilian_teams) do
      brazilian_events.map do |brazilian_event| 
        create(
          :team,
          year: year,
          event_id: brazilian_event.id,
          country: 'BR',
          region: brazilian_event.region,
          division: brazilian_event.region.division
        )
      end
    end
    
    before do
      brazilian_teams
      allow(Setting).to receive(:year).and_return year
      RankingController.assign_judges_to_regions
      judge.reload
    end

    it 'assigns a region to judge' do
      expect(judge.judging_region_id).to eq region.id
    end

    it 'assign to same region as the event' do
      expect(judge.judging_region_id).to be(in_person_event.region_id)
    end

    context 'when there is brazilian judge' do
      let(:judge_country) { 'BR' }
      let(:judge_event) { in_person_event_brazilian_event }
      let(:in_person_event_brazilian_event) do
        create(:event, region_id: south_american_region_ids.sample, whentooccur: whentooccur_event)
      end
      
      it 'assign to same region as the event' do
        expect(judge.judging_region_id).to be(judge_event.region_id)
      end
    end
    
    context 'when the event is virtual' do
      let(:regions) { create_list(:region, 10) }
      let!(:teams) do
        regions.map do |region|
          create(:team, region_id: region.id, year: year)
        end
      end

      let(:judge_event) do
        virtual_event
      end

      let(:region_ids) do
        regions.map(&:id)
      end

      it 'assigns a region to judge' do
        expect(judge.judging_region_id).to_not be_nil
        expect(judge.judging_region_id).to satisfy { |judging_region_id| region_ids.include?(judging_region_id) }
      end
    end
  end
end
