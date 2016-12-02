web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -v -e $RACK_ENV -c $SIDEKIQ_SERVER_LIMIT -q default -q mailers -q elasticsearch
