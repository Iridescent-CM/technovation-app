
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
    include_examples 'validates images size of', :avatar, 100.kilobytes
  end

  describe 'callbacks' do
    it { is_expected.to callback(:check_event_region).before(:save) }
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
        event_id
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

  describe '.check_event_region' do
    let(:event_id) { 1 }
    let(:event){ build :event, :virtual_event, id: event_id }
    let(:region) { build(:region) }
    let(:team) { build(:team, region: region, event_id: event_id) }
    let(:region_changed?) { false }
    let(:has_a_virtual_event?) { false }


    before do
      allow(team).to receive(:region_id_changed?).and_return region_changed?
      allow(team).to receive(:has_a_virtual_event?).and_return has_a_virtual_event?
    end

    it 'dont change the team event' do
      team.check_event_region
      expect(team.event_id).to be(event_id)
    end

    context 'when the team region is changed' do
      let(:region_changed?) { true }

      it 'remove the team event' do
        team.check_event_region
        expect(team.event_id).to be(nil)
      end
      context 'and team event is virtual' do
        let(:region_changed?) { true }
        let(:has_a_virtual_event?) { true }

        it 'dont change the team event' do
          team.check_event_region
          expect(team.event_id).to be(event_id)
        end
      end
    end
  end
  describe '.has_a_virtual_event?' do
    subject(:team) { build(:team, event_id: event_id).has_a_virtual_event? }
    let(:event) { build(:event, :virtual_event) }
    let(:event_id) { Faker::Number.number 4 }

    before do
      allow(Event).to receive(:find).and_return(event)
    end

    it { is_expected.to be true }

    context 'when is not a virtual event' do
      let(:event) { build(:event, :non_virtual_event) }

      it { is_expected.to be false }
    end

    context 'when there is not a event' do
      let(:event_id) { nil }
      let(:event) { nil }

      it { is_expected.to be false }
    end
  end



end
