require 'rails_helper'
include WebMock::API

describe Team, type: :model do
  subject(:team) { build(:team) }

  describe 'validations' do
    shared_examples 'validates images size of' do |field, filesize|
      it do
        is_expected
          .to validate_attachment_size(field)
          .less_than(filesize)
      end
    end

    include_examples 'validates images size of', :screenshot1, 100.kilobytes
    include_examples 'validates images size of', :screenshot2, 100.kilobytes
    include_examples 'validates images size of', :screenshot3, 100.kilobytes
    include_examples 'validates images size of', :screenshot4, 100.kilobytes
    include_examples 'validates images size of', :screenshot5, 100.kilobytes
    include_examples 'validates images size of', :logo, 100.kilobytes
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:confirm_region) }
    it { is_expected.to respond_to(:confirm_acceptance_of_rules) }
  end

  describe '.update_division' do
    let(:region_submisssion_enabled?) { true }

    before do
      allow(Setting)
        .to receive(:get_boolean)
        .with('manual_region_selection')
        .and_return(region_submisssion_enabled?)
    end

    after do
      team.update_division
    end

    it  { expect(team).to receive(:new_update_division) }
    it  { expect(team).to_not receive(:old_update_division) }

    context 'when the feature manual_region_selection is off' do
      let(:region_submisssion_enabled?) { false }

      it  { expect(team).to receive(:old_update_division) }
      it  { expect(team).to_not receive(:new_update_division) }
    end
  end

  describe '.new_update_division' do
    it 'sets team division to be equal to its own region' do
      team.division = nil
      team.new_update_division
      expect(team.division).to eq(team.region.division)
    end
  end

  describe '.required_fields' do
    subject { team.required_fields }
    let(:region_submisssion_enabled?) { true }

    before do
      allow(Setting)
        .to receive(:get_boolean)
        .with('manual_region_selection')
        .and_return(region_submisssion_enabled?)
    end

    let(:expected_required_fields) do
      %w(
        code
        pitch
        plan
        confirm_region
        confirm_acceptance_of_rules
      )
    end

    it { is_expected.to contain_exactly(*expected_required_fields) }

    context 'when the feature manual_region_selection is off' do
      let(:region_submisssion_enabled?) { false }

      it { is_expected.to_not include('confirm_region') }
      it { is_expected.to_not include('confirm_acceptance_of_rules') }
    end
  end
end
