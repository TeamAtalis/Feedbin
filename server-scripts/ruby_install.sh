#!/bin/bash -i

# Install dependecys for ruby
sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

# Install dependeces for rails
sudo apt-get install nodejs

# Install dependences of some gems
sudo apt-get install libpq-dev # For pg gem
sudo apt-get install libldap2-dev # For idn-ruby
sudo apt-get install libidn11-dev # For idn-ruby
sudo apt-get install -y libvips

# Install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Reload the bash profile for find rbenv
source ~/.bash_profile

# Install ruby 3.2.2
rbenv install 3.2.2
rbenv global 3.2.2

# Install bundler
gem install bundler

# Install rails
gem install rails 