TechnovationApp::Application.configure do
  config.middleware.insert_before(Rack::Lock, Rack::Block) do
    ip_pattern '173.245.50.126' do
      halt 404
    end
  end
end
