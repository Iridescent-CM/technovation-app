require 'rails_helper'

describe Rubric, type: :model do
  describe '' do
    subject(:rubric) { build(:rubric) }

    it { is_expected.to respond_to(:has_scored) }

    context 'when not set up' do
      subject { rubric.has_scored }

      it { is_expected.to be false }
    end
  end
end
