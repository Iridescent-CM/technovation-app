describe 'teams/index.html.slim', type: :view do
  subject { render }
  let(:teams) { build_list(:team, 11) }
  let(:seeds) { 0 }
  let(:season_year) { 2015 }

  before do
    assign(:teams, Kaminari.paginate_array(teams).page(1).per(10))
    assign(:seed, seeds)
    assign(:season, season_year)
  end

  describe 'categories' do
    it do
      expect(Category).to receive(:of_season).with(season_year).and_return([])
      subject
    end
  end

  describe 'pagination' do
    it { is_expected.to have_selector('.pagination') }
    it { is_expected.to have_selector('.team', count: 10) }
    it { is_expected.to have_selector('a[rel="next"]') }
  end
end
