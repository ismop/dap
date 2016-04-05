web: bundle exec puma -C ./config/puma.rb
worker: bundle exec sidekiq -c 10 --queue $DAP_QUEUE_NAME 
clock: bundle exec clockwork ./app/clock.rb
