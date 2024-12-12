release: bundle exec rails db:migrate tmp:cache:clear assets:clean airbrake:deploy
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -v -e $RACK_ENV -c $SIDEKIQ_SERVER_LIMIT -q default -q mailers
console: bundle exec bin/rails console
