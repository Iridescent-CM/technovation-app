

describe 'teams/edit_submission.html.slim', type: :view do
  subject { render }
  let(:events) { build_list(:event, 1) }
  let(:region_submisssion_enabled?) { true }
  let(:user) { create(:user) }
  let(:team) { double }
  let(:submission_symbol) { :submitted }
  let(:season_year) { 2010 }

  before do
    allow(Setting).to receive(:year).and_return(season_year)
    allow(Event)
      .to receive(:open_for_signup)
      .and_return(events)
    assign(:team, build(:team))

    allow_any_instance_of(User).to receive(:current_team).and_return(team)
    allow(team).to receive(:submission_symbol).and_return(submission_symbol)
    allow(Setting)
      .to receive(:get_boolean)
      .with('manual_region_selection')
      .and_return(region_submisssion_enabled?)
    sign_in user
  end

  it { is_expected.to have_selector('#region_submisssion') }
  it { is_expected.to have_selector('.submission-status') }

  describe 'categories' do 
    it do
      expect(Category).to receive(:of_season).with(season_year).and_return([])
      subject
    end
  end

  context 'display the submittion status' do 
    it 'there is a message status box' do
      is_expected.to have_selector('.submission-status .alert.alert-success')
    end

    let(:expected_status) do
      I18n.t(submission_symbol, scope: [:team, :submission, :status])
    end

    it { is_expected.to have_text(expected_status) }

    context 'when the submisssion-status is different of submitted' do
      let(:submission_symbol) { :any_other_status }
      it do
        is_expected.to have_selector('.submission-status .alert.alert-warning')
      end
      context 'when the user there is not a team' do
        let(:team) { nil }
        before do
          allow_any_instance_of(User).to receive(:current_team).and_return(nil)
        end
        it do
          is_expected.to_not have_selector('.submission-status')
        end
      end
    end
  end

  context 'when the feature manual_region_selection is off' do
    let(:region_submisssion_enabled?) { false }
    it { is_expected.to_not have_selector('#region_submisssion') }
  end
end
