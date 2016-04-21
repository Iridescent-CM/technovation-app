require 'rails_helper'

describe RankingController, type: :controller do
  describe 'assign_judges_to_regions' do
    let!(:judge) do
      create(
        :user,
        :judge,
        judging_region_id: nil,
        event_id: judge_event.id,
        home_country: judge_country
      )
    end
    let(:in_person_event) do
      create(:event, region_id: region.id, whentooccur: whentooccur_event)
    end
    let(:judge_event) { in_person_event }
    let(:whentooccur_event) { Faker::Date.forward(10) }
    let(:year) { whentooccur_event.year }
    let!(:region) { create(:region, id: nil) }
    let!(:virtual_event) { create(:event, :virtual_event, whentooccur: whentooccur_event) }
    let(:judge_country) { 'CH' }
    let!(:teams) { create_list(:team, 10, region_id: region.id, year: year) }
    let(:ms_division) { 0 }
    let(:hs_division) { 1 }
    
    before do
      allow(Setting).to receive(:year).and_return year
    end

    it 'assign to same region as the event' do
      RankingController.assign_judges_to_regions
      judge.reload
      expect(judge.judging_region_id).to be(in_person_event.region_id)
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
    end

    context 'when there is brazilian judge' do
      let(:judge_country) { 'BR' }
      let(:judge_event) { in_person_event_brazilian_event }
      let(:in_person_event_brazilian_event) do
        create(
          :event,
          region_id: south_american_regions.sample.id,
          whentooccur: whentooccur_event
        )
      end

      let(:ms_south_american_region) do
        create(:region, region_name: "MS - South America", division: ms_division) 
      end
      
      let(:hs_south_american_region) do
        create(:region, region_name: "HS - South America", division: hs_division) 
      end
      
      let!(:south_american_regions) do 
        [
          ms_south_american_region,
          hs_south_american_region
        ]
      end
      
      let(:brazilian_team_region) { judge_event.region }
      let(:brazilian_team_division) { judge_event.region.division }
      let(:brazilian_team_event) { judge_event }
      
      let!(:brazilian_teams) do
          create_list(
            :team,
            10,
            year: year,
            event_id: judge_event.id,
            country: 'BR',
            region:  brazilian_team_region,
            division: brazilian_team_division
          )
      end

      it 'assign to same region as the event' do
        RankingController.assign_judges_to_regions
        judge.reload
        expect(judge.judging_region_id).to be(judge_event.region_id)
      end
      
      context 'and the event is virtual' do
        let(:judge_event) { virtual_event }
        let(:brazilian_team_region) { south_american_regions.sample  }
        let(:brazilian_team_division) { brazilian_team_region.division }

        
        it 'assigns a region to judge' do
          RankingController.assign_judges_to_regions
          judge.reload
          expect(judge.judging_region_id).to_not be_nil
          expect(judge.judging_region_id).to satisfy do |judging_region_id|
            south_american_regions.map(&:id).include?(judging_region_id)
          end
        end
      end
    end
  end
end
