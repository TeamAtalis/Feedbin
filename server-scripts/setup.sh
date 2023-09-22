#!/bin/bash 

# Define colors for the script
Color_Off='\033[0m'       # Text Reset
Green='\033[0;32m'        # Green
Blue='\033[0;34m'         # Blue
Red='\033[91m'		  # Red

# Precompile the front-end aplication
rails assets:precompile

# Install postgres and start the service
echo -e "${Green}Start installing postgres ${Blue} [sudo apt install postgresql postgresql-contrib] ${Color_Off}"
sudo apt install postgresql postgresql-contrib
echo -e "${Green}Init the postgres service ${Blue} [sudo systemctl start postgresql.service] ${Color_Off}"
sudo systemctl start postgresql.service

# Define ports for postgres service

# Create user and export vars and ports
bash -c 'export POSTGRES_USERNAME=postgres; exec bash'

# Check if redis-server is installed
if ! redis-cli --version >/dev/null 2>&1; then
    # Install redis
    echo "${Red}Redis is not installed.${Green} Installing redis-server...${Color_Off}"
    sudo apt install redis-server -y 
fi

# If redis-server is not running, run it
if ! pgrep redis-server > /dev/null; then
    echo "${Red}Redis server is not running.${Red}"
    redis-server &
fi

#set environment var to db
# bin/rails db:environment:set RAILS_ENV=development
rails db:environment:set RAILS_ENV=development

# Init the db
rails db:drop
rails db:setup
rails db:migrate

# Init the app
cd .. # go to the root path of the app
rails s -b 0.0.0.0 &