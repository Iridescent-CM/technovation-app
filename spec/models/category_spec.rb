require 'rails_helper'

describe Category, type: :model do
  describe 'of season' do
    subject { described_class.of_season(season_year) }
    let(:season_year) { 2016 }

    it 'returns only the category of the season' do
      expect(Category).to receive(:where).with(year: season_year)
      subject
    end
  end
end
