require 'rails_helper'

describe RubricsController, type: :controller do
  describe '.index' do
    let(:event_id) { 1 }
    let(:event){ build(:event, :non_virtual_event, id: event_id, whentooccur: whentooccur_event) }
    let(:whentooccur_event) { Faker::Date.forward(10) }
    let(:user) { build(:user, :judge, event_id: event_id) }
    let(:teams) { build_list(:team, 3, event: event) }
    let(:submission_eligible?) { true }
    let(:today) { Setting.now }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      allow(Setting)
        .to receive(:judgingRound)
        .and_return(judging_round)
      allow(Setting)
        .to receive(:year)
        .and_return(2016)
      allow(Setting)
        .to receive(:now)
        .and_return(today)
      allow(Team)
        .to receive(:find)
        .with(user.event_id)
        .and_return(teams)
      allow(Team)
        .to receive(:has_event)
        .with(event)
        .and_return(teams)
      allow_any_instance_of(Team)
        .to receive(:submission_eligible?)
        .and_return(true)
      allow(Event).to receive(:find)
        .with(event_id)
        .and_return(event)
    end

    context 'when its quarterfinals time' do
      let(:judging_round) { 'quarterfinal' }
      let(:today) { whentooccur_event }

      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end

      context 'and its a virtual event' do
        let(:region) { build(:region) }
        let(:event) { create(:event, :virtual_event, id: event_id, whentooccur: whentooccur_event, region: region) }
        let(:teams) { create_list(:team, 3, event_id: event.id, year: Setting.year, region: region) }
        let(:user) { create(:user, :judge, event: event, judging_region: region) }

        it 'shows a sample of teams for the virtual event' do
          get :index
          expect(assigns[:teams]).not_to be_empty
        end
      end
    end

    context 'when its semifinals time' do
      let(:judging_round) { 'semifinal' }
      let(:today) { whentooccur_event }
      let(:teams) { create_list(:team, 3, event: event, issemifinalist: true, year: Setting.year) }
      let(:user) { build(:user, :judge, event_id: event_id, semifinals_judge: true) }

      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end

      context 'and its a virtual event' do
        let(:event) { build(:event, :virtual_event, id: event_id, whentooccur: whentooccur_event) }
        let(:teams) { create_list(:team, 3, event: event, issemifinalist: true, year: Setting.year) }

        it 'shows a sample of teams for the virtual event' do
          get :index
          expect(assigns[:teams]).not_to be_empty
        end
      end
    end

    context 'when its finals time' do
      let(:judging_round) { 'final' }
      let(:today) { whentooccur_event }
      let(:teams) { create_list(:team, 3, isfinalist: true, year: Setting.year) }
      let(:user) { build(:user, :judge, event_id: event_id, finals_judge: true) }
      
      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end
    end
  end
end
