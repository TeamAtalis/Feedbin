#!/bin/bash -i

# Define colors for the script
Color_Off='\033[0m'       # Text Reset
Green='\033[0;32m'        # Green
Blue='\033[0;34m'         # Blue
Red='\033[91m'		  # Red

# Move to root folder
cd ..

# Install postgres and start the service
echo -e "${Green}Start installing postgres ${Blue} [sudo apt install postgresql postgresql-contrib] ${Color_Off}"
sudo apt install postgresql postgresql-contrib
echo -e "${Green}Init the postgres service ${Blue} [sudo systemctl start postgresql.service] ${Color_Off}"
sudo systemctl start postgresql.service

# Install dependecys for ruby
echo -e "${Green}Install dependecys for ruby ${Blue} [sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev] ${Color_Off}"
sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
echo -e "${Green}Install dependecys for ruby ${Blue} [sudo apt-get install nodejs] ${Color_Off}"
sudo apt-get install nodejs

# Install dependences of some gems
echo -e "${Green}Install more dependecys for ruby ${Blue} [sudo apt-get install libpq-dev libldap2-dev libidn11-dev libvips] ${Color_Off}"
sudo apt-get install libpq-dev # For pg gem
sudo apt-get install libldap2-dev # For idn-ruby
sudo apt-get install libidn11-dev # For idn-ruby
sudo apt-get install -y libvips

# Install rbenv
echo -e "${Green}Install rbenv ${Color_Off}"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Reload the bash profile for find rbenv
source ~/.bash_profile

# Install ruby 3.2.2
echo -e "${Green}Install Ruby 3.2.2 ${Color_Off}"
rbenv install 3.2.2
rbenv global 3.2.2

# Install bundler
echo -e "${Green}Install bundler ${Color_Off}"
gem install bundler

# Install rails
echo -e "${Green}Install rails ${Color_Off}"
gem install rails 

# Reload the bash profile for find rbenv
source ~/.bash_profile

# Install gems for the project
echo -e "${Green}Install all gems for the project ${Color_Off}"
bundle install

# Reboot the server
reboot
