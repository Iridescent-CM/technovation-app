
describe "teams/edit_submission.html.slim", :type => :view do
  subject { render }
  let(:events) { build_list(:event, 1) }
  let(:region_submisssion_enabled?) { true }

  before do
    allow(Event)
      .to receive(:open_for_signup)
      .and_return(events)
    assign(:team, build(:team))

    allow(Setting)
      .to receive(:get_boolean)
      .with('manual_region_selection')
      .and_return(region_submisssion_enabled?)
  end

  it { is_expected.to have_selector("#region_submisssion") }

  context 'when the feature manual_region_selection is off' do
    let(:region_submisssion_enabled?) { false }
    it { is_expected.to_not have_selector('#region_submisssion') }
  end
end
