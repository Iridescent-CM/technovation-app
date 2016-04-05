
describe "teams/index.html.slim", :type => :view do
  subject { render }
  let(:teams) { build_list(:team, 11) }

  before do
    assign(:teams, teams)
  end

  describe 'pagination' do
    it{ is_expected.to have_selector('.pagination') }
    it { is_expected.to have(11).items }
  end
end
