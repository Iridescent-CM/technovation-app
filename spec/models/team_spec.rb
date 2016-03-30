require 'rails_helper'
require 'webmock'
include WebMock::API

describe Team, type: :model do

  context '.update' do
    before do
      default_response = {
        status: 200,
        body: '{"results":[]}',
        headers: {}
      }
      stub_request(:any, /.*/).to_return(default_response)

    end

    it { should validate_attachment_size(:screenshot1).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot2).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot3).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot4).less_than(100.kilobytes) }
    it { should validate_attachment_size(:screenshot5).less_than(100.kilobytes) }
    it { should validate_attachment_size(:logo).less_than(100.kilobytes) }
  end
end
