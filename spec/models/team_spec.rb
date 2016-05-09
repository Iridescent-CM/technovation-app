require 'rails_helper'
include WebMock::API

describe Team, type: :model do
  subject(:team) { build(:team) }

  describe 'validations' do
    shared_examples 'validates file size of' do |field, filesize|
      it do
        is_expected
          .to validate_attachment_size(field)
          .less_than(filesize)
      end
    end

    include_examples 'validates file size of', :screenshot1, 100.kilobytes
    include_examples 'validates file size of', :screenshot2, 100.kilobytes
    include_examples 'validates file size of', :screenshot3, 100.kilobytes
    include_examples 'validates file size of', :screenshot4, 100.kilobytes
    include_examples 'validates file size of', :screenshot5, 100.kilobytes
    include_examples 'validates file size of', :logo, 100.kilobytes
    include_examples 'validates file size of', :avatar, 100.kilobytes
    include_examples 'validates file size of', :plan, 500.kilobytes
  end

  describe 'callbacks' do
    it { is_expected.to callback(:check_event_region).before(:save) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:confirm_region) }
    it { is_expected.to respond_to(:confirm_acceptance_of_rules) }
  end

  describe '.update_division' do
    it 'sets team division to be equal to its own region' do
      team.division = nil
      team.update_division
      expect(team.division).to eq(team.region.division)
    end
  end

  describe '.required_fields' do
    subject { team.required_fields }

    let(:expected_required_fields) do
      %i(event_id
         code
         pitch
         plan
         confirm_region
         confirm_acceptance_of_rules)
    end

    it { is_expected.to contain_exactly(*expected_required_fields) }
  end

  describe '.check_event_region' do
    let(:event_id) { 1 }
    let(:event) { build :event, :virtual_event, id: event_id }
    let(:region) { build(:region) }
    let(:team) { build(:team, region: region, event_id: event_id) }
    let(:region_changed?) { false }
    let(:has_a_virtual_event?) { false }

    before do
      allow(team).to receive(:region_id_changed?).and_return region_changed?
      allow(team).to receive(:has_a_virtual_event?).and_return has_a_virtual_event?
      allow(team).to receive(:persisted?).and_return true
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
    let(:event) { build(:event, :virtual_event) }

    subject(:team) { build(:team, event: event).has_a_virtual_event? }

    it { is_expected.to be true }

    context 'when is not a virtual event' do
      let(:event) { build(:event, :non_virtual_event) }
      it { is_expected.to be false }
    end

    context 'when there is not a event' do
      let(:event) { nil }
      it { is_expected.to be false }
    end
  end

  describe '.ineligible?' do
    subject { team.ineligible? }

    let(:team) { build(:team) }
    let(:student) { build(:user, :student) }
    let(:allow_new_logic?) { true }
    let(:allow_new_logic_for_students?) { true }
    let(:user_ineligible?) { true }
    let(:team_members) { [student] }

    before do
      Setting.find_or_create_by!({
        key: 'allow_ineligibility_logic',
        value: allow_new_logic?.to_s
      })

      Setting.find_or_create_by!({
        key: 'allow_ineligibility_logic_for_students',
        value: allow_new_logic_for_students?.to_s
      })

      allow(student).to receive(:ineligible?).and_return(user_ineligible?)
      allow(team).to receive(:members).and_return(team_members)
    end

    context 'when team contains at least one ineligible student' do
      it { is_expected.to be true }
    end

    context 'when allow_ineligibility_logic_for_students is off' do
      let(:allow_new_logic_for_students?) { false }
      let(:user_ineligible?) { true }

      context 'and team has more than 5 students' do
        let(:number_of_students) { Faker::Number.between(6) }
        let(:team_members) { [student] * number_of_students }

        it { is_expected.to be true }
      end

      context 'and team has no student' do
        let(:user_coach) { build(:user, :coach) }
        let(:user_mentor) { build(:user, :mentor) }
        let(:team_members) { [user_mentor, user_coach] }

        it { is_expected.to be true }
      end

      context 'and team has 5 students and at least one coach and one mentor' do
        let(:user_coach) { build(:user, :coach) }
        let(:user_mentor) { build(:user, :mentor) }
        let(:team_members) { [student, student, student, student, student, user_mentor, user_coach] }

        it { is_expected.to be false }
      end
    end
  end

  describe 'by_country' do
    subject { Team.by_country(country) }
    let(:country) { Faker::Address.country_code }
    let(:current_relation) { double(where: nil) }
    before do
      allow(Team).to receive(:current).and_return(current_relation)
    end

    it 'calls current scope' do
      expect(Team).to receive(:current)
      subject
    end
    it 'filters by country' do
      expect(current_relation).to receive(:where).with(country: country)
      subject
    end
  end

  describe '.submission_eligible' do
    subject { team.submission_eligible? }
    let(:plan) { File.new("./spec/support/files/plan_example.pdf") }
    let(:team) { build(:team, event_id: 1, confirm_acceptance_of_rules: true, confirm_region: true, plan: plan) }

    it { is_expected.to be true }

    context ' missing at least one required field for submission' do
      let(:plan) { nil }
      it { is_expected.to be false }
    end
  end

end
