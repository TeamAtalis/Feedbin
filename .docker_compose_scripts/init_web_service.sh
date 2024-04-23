#! /bin/bash

# Create Backend
RAILS_ENV=development rails db:create
PGPASSWORD=$POSTGRES_PASSWORD psql -h postgres  --set ON_ERROR_STOP=1 --quiet --no-psqlrc --output /dev/null --file /app/db/structure.sql feedbin_development
RAILS_ENV=development rails db:migrate
RAILS_ENV=development rails db:seed

# Front-End
RAILS_ENV=development rails assets:precompile

# Run server
RAILS_ENV=development rails s -b '0.0.0.0'