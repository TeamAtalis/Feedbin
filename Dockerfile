FROM ruby:3.2.2

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get upgrade -y &&  apt-get install -y \
  git \
  build-essential \
  nodejs libldap2-dev postgresql-client \
  libffi-dev                         \
  libidn11-dev                       \
  libpq-dev                          \
  libreadline-dev                    \
  libssl-dev                         \
  libvips                            \
  libxml2-dev                        \
  libxslt1-dev                       \
  rustc                              \
  zlib1g-dev

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY . /app
RUN rm -rf tmp/*
RUN rm Gemfile.lock
#RUN gem install twitter
RUN gem install bundler 
RUN bundle install

# Expón el puerto 3000 para la aplicación Rails
EXPOSE 3000