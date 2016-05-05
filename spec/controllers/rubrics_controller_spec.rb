require 'rails_helper'

describe RubricsController, type: :controller do
  describe "GET #new" do
    it "restricts judges in the conflict region" do
      Setting.create!({
        key: 'quarterfinalJudgingOpen',
        value: Date.today - 1
      })

      Setting.create!({
        key: 'quarterfinalJudgingClose',
        value: Date.today + 1
      })

      team = FactoryGirl.create(:team)
      judge = FactoryGirl.create(:user,
                                 role: :judge,
                                 conflict_region_id: team.region_id)

      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in(judge)

      get :new, team: team.id

      expect(response.status).to eq(302)
    end
  end

  describe '.index' do
    let(:event_id) { 1 }
    let(:event) { build(:event, :non_virtual_event, id: event_id, whentooccur: whentooccur_event) }
    let(:whentooccur_event) { Faker::Date.forward(10) }
    let(:user) { build(:user, :judge, event_id: event_id) }
    let(:teams) { build_list(:team, 5, event: event) }
    let(:submission_eligible?) { true }
    let(:round_start) { Faker::Date.forward(2) }
    let(:round_end) { round_start + 4.day }
    let(:today) { Faker::Date.between(round_start, round_end) }
    let(:judging_round) { '' }
    let(:region) { build(:region) }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      allow(Setting)
        .to receive(:judgingRound)
        .and_return(judging_round)

      allow(Setting)
        .to receive(:year)
        .and_return(Date.today.year)

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

      allow(Setting)
        .to receive(:get_date)
        .with(judging_round+"JudgingOpen")
        .and_return(round_start)

      allow(Setting)
        .to receive(:get_date)
        .with(judging_round+"JudgingClose")
        .and_return(round_end)

      allow(Setting)
        .to receive(:anyJudgingRoundActive?)
        .and_return(!judging_round.empty?)
    end

    context 'when its not time to judge' do
      let(:today) { Faker::Date.between(round_start - 2.day, round_start - 1.day) }

      it 'does not show teams to be judged' do
        get :index
        expect(assigns[:teams]).to be_empty
      end
    end

    context 'when its quarterfinals time' do
      let(:judging_round) { 'quarterfinal' }

      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end

      context 'and its a virtual event' do
        let(:event) { build(:event, :virtual_event, id: event_id, whentooccur: whentooccur_event, region: region) }
        let(:teams) { build_list(:team, 5, event_id: event.id, year: Setting.year, region: region) }
        let(:user) { build(:user, :judge, event: event, judging_region: region) }

        before do
          allow(Event).to receive(:virtual_for_current_season).and_return(event)

          allow(Team).to receive(:where).with(region: user.judging_region, event_id: event.id)
            .and_return(teams)
        end

        it 'shows a three of the teams for virtual event' do
          get :index
          expect(assigns[:teams].length).to eq 3
        end

        context 'and some teams has been judged already' do
          let(:keep_team_1) { build(:team, event_id: event.id, year: Setting.year, region: region) }
          let(:keep_team_2) { build(:team, event_id: event.id, year: Setting.year, region: region) }
          let(:keep_team_3) { build(:team, event_id: event.id, year: Setting.year, region: region) }
          let(:do_not_keep_team) { build(:team, event_id: event.id, year: Setting.year, region: region) }
          let(:teams) { [keep_team_1, keep_team_2, keep_team_3, do_not_keep_team] }

          before do
            allow(keep_team_1).to receive(:num_rubrics).and_return(1)
            allow(keep_team_2).to receive(:num_rubrics).and_return(1)
            allow(keep_team_3).to receive(:num_rubrics).and_return(1)
            allow(do_not_keep_team).to receive(:num_rubrics).and_return(2)
          end

          it 'does not show teams that has been judged more than others' do
            get :index
            expect(assigns[:teams]).to_not contain_exactly(do_not_keep_team)
          end

          it 'shows the three teams that has been less judged' do
            get :index
            expect(assigns[:teams].length).to be 3
          end
        end
      end
    end

    context 'when its semifinals time' do
      let(:judging_round) { 'semifinal' }
      let(:teams) { build_list(:team, 5, event: event, is_semi_finalist: true, year: Setting.year) }
      let(:user) { build(:user, :judge, event_id: event_id, semifinals_judge: true) }

      before do
        allow(Team).to receive(:where).with(is_semi_finalist: true).and_return(teams)
      end

      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end

      context 'and its a virtual event' do
        let(:event) { build(:event, :virtual_event, id: event_id, whentooccur: whentooccur_event) }
        let(:teams) { build_list(:team, 5, event: event, is_semi_finalist: true, year: Setting.year) }

        it 'shows a sample of teams for the virtual event' do
          get :index
          expect(assigns[:teams].length).to be 3
        end
      end
    end

    context 'when its finals time' do
      let(:judging_round) { 'final' }
      let(:teams) { build_list(:team, 5, isfinalist: true, year: Setting.year) }
      let(:user) { build(:user, :judge, event_id: event_id, finals_judge: true) }

      before do
        allow(Team).to receive(:where).with(isfinalist: true).and_return(teams)
      end

      it 'shows all teams for this event' do
        get :index
        expect(assigns[:teams]).to eq(teams)
      end
    end

    describe 'brazilian cases' do
      let(:judging_round) { 'quarterfinal' }
      let(:brazil) { 'BR' }
      let(:non_brazilian_country) { 'CH' }
      let(:region) { build(:region) }
      let(:judge_country) { non_brazilian_country }
      let(:user) do
        build(
          :user, :judge,
          event: event,
          judging_region: region,
          home_country: judge_country
        )
      end

      let(:non_brazilian_teams) do
        build_list(
          :team, 3,
          event_id: event.id,
          year: Setting.year,
          region: region,
          country: non_brazilian_country
        )
      end

      let(:brazilian_teams) do
        build_list(
          :team, 3,
          event_id: event.id,
          year: Setting.year,
          region: region,
          country: brazil
        )
      end

      let(:teams) do
        non_brazilian_teams + brazilian_teams
      end

      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'shows only non brazilian teams' do
        get :index

        expect(assigns[:teams]).to eq non_brazilian_teams
      end

      context 'when judge is brazilian' do
        let(:judge_country) { brazil }

        it 'shows only brazilian teams' do
          get :index
          expect(assigns[:teams]).to eq brazilian_teams
        end
      end
    end
  end
end
