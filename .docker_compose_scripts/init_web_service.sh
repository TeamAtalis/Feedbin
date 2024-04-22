#! /bin/bash

rails assets:precompile 

RAILS_ENV=development rails db:create
psql -h feedbin-postgres-1 --set ON_ERROR_STOP=1 --quiet --no-psqlrc --output /dev/null --file /app/db/structure.sql feedbin_development
RAILS_ENV=development rails db:migrate

#rails db:seed
#rails s -b '0.0.0.0'