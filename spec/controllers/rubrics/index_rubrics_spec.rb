require "rails_helper"

RSpec.describe RubricsController do
  describe 'GET #index' do
    let(:region) { create(:region) }
    let(:event) { create(:event, when_to_occur: Date.today) }
    let(:judge) { create(:user, role: :judge, event: event,
                                              judging_region: region,
                                              semifinals_judge: true,
                                              finals_judge: true) }

    before do
      Season.open!(Date.today.year)
      Quarterfinal.open!(close: Date.today + 1)

      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in(judge)
    end

    it "assigns the event" do
      get :index
      expect(assigns[:event]).to eq(event)
    end

    context 'when its not time to judge' do
      before { Quarterfinal.close! }

      it 'does not show teams to be judged' do
        get :index
        expect(assigns[:teams]).to be_empty
      end
    end

    context "when the judge doesn't have an event assigned" do
      it "sets teams to an empty array" do
        no_events = create(:user, role: :judge, event: nil)
        sign_in(no_events)
        get :index
        expect(assigns[:teams]).to be_empty
      end
    end

    context 'when its quarterfinals time' do
      it 'shows all teams for this event' do
        team = create(:team, :eligible, event: event)
        team2 = create(:team, :eligible)

        get :index
        expect(assigns[:teams]).to eq([team])
      end

      context 'and its a virtual event' do
        let(:teams) { [] }

        before do
          event.update_attributes(is_virtual: true)
          teams = create_list(:team, 5, :eligible, event: event,
                                                   region: region)
        end

        it 'shows three random teams for virtual event' do
          get :index
          expect(assigns[:teams].count).to eq(3)
        end

        context 'and some teams has been judged already' do
          before do
            teams.each do |team|
              3.times { create(:rubric, team: team) }
            end

            create(:rubric, team: teams[0])
            create(:rubric, team: teams[3])
          end

          it 'does not show teams that has been judged more than others' do
            get :index
            expect(assigns[:teams]).not_to include(teams[0])
            expect(assigns[:teams]).not_to include(teams[3])
          end
        end
      end
    end

    context 'when its semifinals time' do
      before do
        Quarterfinal.close!
        Semifinal.open!(close: Date.today + 1)
      end

      it 'shows all teams for this event' do
        team = create(:team, :eligible, is_semi_finalist: true,
                                        event: event)
        team2 = create(:team, :eligible, is_semi_finalist: false,
                                         event: event)

        get :index
        expect(assigns[:teams]).to eq([team])
      end
    end

    context 'when its finals time' do
      before do
        Quarterfinal.close!
        Semifinal.close!
        Final.open!(close: Date.today + 1)
      end

      it 'shows all teams for this event' do
        team = create(:team, :eligible, is_finalist: true,
                                        event: event)
        team2 = create(:team, :eligible, is_finalist: false,
                                         event: event)

        get :index
        expect(assigns[:teams]).to eq([team])
      end
    end

    describe 'brazilian cases' do
      before do
        Quarterfinal.open!(close: Date.today + 1)
        judge.update_attributes(home_country: 'US')
      end

      it 'shows only non brazilian teams' do
        us = create(:team, :eligible, country: 'US', event: event)
        br = create(:team, :eligible, country: 'BR', event: event)

        get :index
        expect(assigns[:teams]).to eq([us])
      end

      context 'when judge is brazilian' do
        before { judge.update_attributes(home_country: 'BR') }

        it 'shows only brazilian teams' do
          us = create(:team, :eligible, country: 'US', event: event)
          br = create(:team, :eligible, country: 'BR', event: event)

          get :index
          expect(assigns[:teams]).to eq([br])
        end
      end
    end
  end
end
