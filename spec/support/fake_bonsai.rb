require 'sinatra/base'

class FakeBonsai < Sinatra::Base
  put '*' do
    json_response 200, 'empty.json'
  end

  patch '*' do
    json_response 200, 'empty.json'
  end

  post '*' do
    json_response 200, 'empty.json'
  end

  delete '*' do
    json_response 200, 'empty.json'
  end

  private
  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
