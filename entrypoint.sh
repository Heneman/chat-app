export RAILS_ENV=production

bundle exec rake db:create db:migrate

rails server -b 0.0.0.0