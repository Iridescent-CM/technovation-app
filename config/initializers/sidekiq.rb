Sidekiq.default_worker_options = {
  backtrace: true,
  retry: 3,
}

Sidekiq.configure_server do |config|
  if database_url = ENV['DATABASE_URL']
    ActiveRecord::Base.establish_connection "#{database_url}?pool=25"
  end
end
