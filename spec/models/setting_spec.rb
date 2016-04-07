require 'rails_helper'

describe Setting, type: :model do
  describe '.get_boolean' do
    subject { Setting.get_boolean(key) }

    let(:key) { 'ANY KEY' }
    let(:value) { 'true' }
    let(:expected_value) { true }
    let(:fake_setting) { double(value: value) }

    before do
      allow(Setting)
        .to receive(:find_by!)
        .with(key: key)
        .and_return(fake_setting)
    end

    it { is_expected.to eql expected_value }

    it 'calls find_by with key' do
      expect(Setting).to receive(:find_by!).with(key: key)
      subject
    end

    context 'when an invalid value is used' do
      let(:value) { 'ANY VALUE DIFFERENT OF TRUE OR FALSE' }
      let(:expected_value) { false }

      it { is_expected.to eql expected_value }
    end

    context 'when the key does not exist' do
      let(:expected_value) { false }

      before do
        allow(Setting)
          .to receive(:find_by!)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      it { is_expected.to eql expected_value }
    end
  end
end
