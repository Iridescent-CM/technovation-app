require 'rails_helper'

describe Rubric::CreateToBrazil do
  subject { described_class.run!(year: year, regions: regions, country: country) }

  let(:year) { 2016 }
  let(:regions) { [1, 5] }
  let(:country) { 'BR' }

  before do
    allow(Setting).to receive(:year).and_return(year)
  end

  after do
    subject
  end

  it 'get users from country' do
    expect(User).to receive(:judges_from).with(country)
  end

  it 'get teams from region division and year' do
    expect(Team)
      .to receive(:by_regions_year_and_country)
      .with(regions, year, country)
  end
end
