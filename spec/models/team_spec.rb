require 'rails_helper'
include WebMock::API

describe Team, type: :model do

  context '.update' do

    it { should validate_attachment_size(:screenshot1).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot2).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot3).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot4).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot5).less_than(100.kilobytes) }
    it { should validate_attachment_size(:logo).less_than(100.kilobytes) }

describe Team, type: :model do

  describe 'attributes' do
    subject(:team) { build(:team) }

    it { is_expected.to respond_to(:confirm_region) }
  end
end
