require 'rails_helper'
describe 'teams/show.html.slim', type: :view do
  subject { render }

  let(:season_year) { 2015 }
  let(:team_year) { 2015 }
  let(:submissionOpen?) { true }
  let(:team) { build(:team, id: 123, year: team_year) }
  let(:fake_policy) { double(join?: true, edit?: true) }

  before do
    allow(Setting).to receive(:year).and_return(season_year)
    allow(Setting).to receive(:submissionOpen?).and_return(submissionOpen?)
    allow(view).to receive(:policy).and_return(fake_policy)

    assign(:team, team)
  end

  it { is_expected.to have_selector('#request-join-button') }
  it { is_expected.to have_selector('#edit-team-button') }
  it { is_expected.to have_selector('#edit-submission-button') }

  context 'team year is different from season year' do
    let(:team_year) { 2014 }
    let(:season_year) { 2015 }

    it { is_expected.to_not have_selector('#request-join-button') }
    it { is_expected.to_not have_selector('#edit-team-button') }
    it { is_expected.to_not have_selector('#edit-submission-button') }
  end
end
