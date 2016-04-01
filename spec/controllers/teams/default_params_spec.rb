require_relative "../../../app/controllers/teams/default_params"
require 'rails_helper'

describe Teams::DefaultParams do
  subject { Teams::DefaultParams.params(any_params) }
  let(:region_submisssion_enabled?) { true }

  before do
    allow(Setting)
      .to receive(:get_boolean)
      .with('manual_region_selection')
      .and_return(region_submisssion_enabled?)
  end

  let(:any_params) { {a: 1, b:2 } }
  let(:default_params) do
    { confirm_acceptance_of_rules: false, confirm_region: false }
  end

  it { is_expected.to include any_params }
  it { is_expected.to include default_params }

  context 'when the feature manual_region_selection is off' do
    let(:region_submisssion_enabled?) { false }
    it { is_expected.to include any_params }
    it { is_expected.to_not include default_params }
  end
end
