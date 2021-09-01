Sidekiq.default_worker_options = {
  backtrace: true,
  retry: 3,
}

Sidekiq.configure_server do |config|
  if database_url = ENV['DATABASE_URL']
    pool = ENV.fetch("SIDEKIQ_DB_POOL_SIZE") { 25 }
    ActiveRecord::Base.establish_connection "#{database_url}?pool=#{pool}"
  end
end
