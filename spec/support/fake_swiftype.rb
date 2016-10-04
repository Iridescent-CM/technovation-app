require 'sinatra/base'

class FakeSwiftype < Sinatra::Base
  set :show_exceptions, false

  post '/*' do
    json_response 200, "swiftype_response.json"
  end

  private
  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
