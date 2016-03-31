require 'rails_helper'
include WebMock::API

describe Team, type: :model do
  subject { Team.new }

    it { is_expected.to validate_attachment_size(:screenshot1).less_than(100.kilobytes) }
    it { is_expected.to validate_attachment_size(:screenshot2).less_than(100.kilobytes) }
    it { is_expected.to validate_attachment_size(:screenshot3).less_than(100.kilobytes) }
    it { is_expected.to validate_attachment_size(:screenshot4).less_than(100.kilobytes) }
    it { is_expected.to validate_attachment_size(:screenshot5).less_than(100.kilobytes) }
    it { is_expected.to validate_attachment_size(:logo).less_than(100.kilobytes) }

  describe 'attributes' do
    subject(:team) { build(:team) }

    it { is_expected.to respond_to(:confirm_region) }
  end
end
