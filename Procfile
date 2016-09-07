web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production -c 5 -q default -q mailers
