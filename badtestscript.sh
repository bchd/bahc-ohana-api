cd /repo/ && mkdir /tmp/test-results && bundle install --jobs=4 --retry=3 --path vendor/bundle

bundle exec rake db:create db:migrate db:seed

bundle exec rspec --format progress --out /tmp/test-results/rspec.xml --format progress spec