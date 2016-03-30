require 'rails_helper'
require 'webmock'
include WebMock::API

describe Team, type: :model do

  context '.update' do

    it { should validate_attachment_size(:screenshot1).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot2).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot3).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot4).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot5).less_than(100.kilobytes) }
    it { should validate_attachment_size(:logo).less_than(100.kilobytes) }
  end
end
