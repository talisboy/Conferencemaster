# Clone projects
git clone git@staging.xorro.com:xorro/account.git
git clone git@staging.xorro.com:xorro/website.git
git clone git@staging.xorro.com:xorro/api.git
git clone git@staging.xorro.com:xorro/participant.git
git clone git@staging.xorro.com:xorro/facilitator.git

# Not needed below unless they need to be updated
git clone git@staging.xorro.com:gems/xorro_file.git gems/xorro_file
git clone git@staging.xorro.com:gems/xorro_auth.git gems/xorro_auth
git clone git@staging.xorro.com:gems/xorro_design.git gems/xorro_design
git clone git@staging.xorro.com:gems/xorro_preferences.git gems/xorro_preferences

# Build docker images
docker-compose build

# Setup db user and create databases
docker-compose up -d db

(exit 1)
sleep 2
while [ $? -ne 0 ]; do
  docker-compose exec db sh -c "exec mysql -uroot -pdevRoot -e \"GRANT ALL PRIVILEGES ON *.* TO 'devUser'@'%'; FLUSH PRIVILEGES;\""
  sleep 2
done

docker-compose exec db sh -c "exec mysql -udevUser -pdevAdmin -e '\
  CREATE DATABASE IF NOT EXISTS \`xorroq_api_development\` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
  CREATE DATABASE IF NOT EXISTS \`xorroq_api_test\` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
  CREATE DATABASE IF NOT EXISTS \`xorro_accounts_development\` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
  CREATE DATABASE IF NOT EXISTS \`xorro_accounts_test\` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
  CREATE DATABASE IF NOT EXISTS \`casserver\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; \
'"
docker-compose down

# bundle
docker-compose run --rm api.xorroq gem install bundler -v "~> 1.17.0"
docker-compose run --rm api.xorroq gem update --system 2.7.7
docker-compose run --rm api.xorroq bundle install
docker-compose run --rm api.xorroq gem install rake -v 11.2.2
docker-compose run --rm api.xorroq gem install rake -v 11.3.0
docker-compose run --rm facilitator.xorroq bundle install
docker-compose run --rm participant.xorroq bundle install
docker-compose run --rm website.xorroq bundle install

# Run migrations and load fixtures
docker-compose run --rm api.xorroq bin/rake db:migrate
docker-compose run --rm api.xorroq bin/rake db:fixtures:load
docker-compose run --rm website.xorroq bundle exec rake db:migrate
docker-compose run --rm website.xorroq bundle exec rake db:fixtures:load
