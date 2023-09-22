#!/bin/bash -i
# -i flag is for run the script on interactive mode, if this flag is not there, the source ~/.bashrc will not works. [https://askubuntu.com/questions/64387/cannot-successfully-source-bashrc-from-a-shell-script] 

# install dependecys for ruby
sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

# install dependeces for rails
sudo apt-get install nodejs

# install dependences of some gems
sudo apt-get install libpq-dev # For pg gem
sudo apt-get install libldap2-dev # For idn-ruby
sudo apt-get install libidn11-dev # For idn-ruby
sudo apt-get install -y libvips

# install rbenv for the ruby versions
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# export var for rbenv 
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# reload the var 
source ~/.bashrc

# install ruby with specific version 
rbenv install -v 3.2.2

# set global and local version for ruby 
rbenv global 3.2.2
rbenv local 3.2.2

# install bunlde
gem install bundler

# reload gem instalation 
source ~/.bashrc

# install ruby on rails with rbenv
gem install rails

# install all gems for the project
bundle install
