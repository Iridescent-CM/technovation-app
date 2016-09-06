unless Rails.env.development? or Rails.env.test?
  HireFire::Resource.configure do |config|
    config.dyno(:sidekiq_worker) do
      HireFire::Macro::Sidekiq.queue
    end
  end
end
