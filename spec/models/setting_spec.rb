require 'rails_helper'

describe Setting, type: :model do
  describe '.get_boolean' do
    subject { Setting.send(:get_boolean, key) }

    let(:key) { 'ANY KEY' }
    let(:value) { true }

    before { Setting.find_or_create_by!(key: key, value: value) }

    it { is_expected.to be true }

    context 'when an invalid value is used' do
      let(:value) { 'ANY VALUE DIFFERENT OF TRUE OR FALSE' }
      it { is_expected.to be false }
    end

    context 'when the key does not exist' do
      it "is false" do
        expect(Setting.send(:get_boolean, "no exist")).to be false
      end
    end
  end

  describe '.get_date' do
    subject { Setting.get_date(key) }

    let(:key) { 'ANY KEY' }
    let(:value) { expected_value.to_s }
    let(:expected_value) { Faker::Date.between(2.days.ago, Date.today) }
    let(:fake_setting) { double(value: value) }
    let(:now) { Time.now }

    before do
      allow(Setting)
        .to receive(:find_by!)
        .with(key: key)
        .and_return(fake_setting)

      allow(Setting)
        .to receive(:now)
        .and_return(now)
    end

    it { is_expected.to eql expected_value }

    it 'calls find_by with key' do
      expect(Setting).to receive(:find_by!).with(key: key)
      subject
    end

    context 'when an invalid value is used' do
      let(:value) { 'ANY VALUE DIFFERENT OF A DATE' }
      let(:expected_value) { nil }

      it { is_expected.to eq(expected_value) }
    end

    context 'when the key does not exist' do
      let(:expected_value) { nil }

      before do
        allow(Setting)
          .to receive(:find_by!)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      it { is_expected.to eq(expected_value) }
    end
  end
end
