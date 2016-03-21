require 'rails_helper'

describe Event, type: :model do

  describe '.is_virtual' do
    subject(:event) { build(:event) }

    it { is_expected.to respond_to(:is_virtual) }

    context 'when not set up' do
      subject { event.is_virtual }

      it { is_expected.to be_nil }
    end
  end
end
