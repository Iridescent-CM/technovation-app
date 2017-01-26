require 'sidekiq-status'

Sidekiq.default_worker_options = {
  backtrace: true,
  retry: 3,
}

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end
