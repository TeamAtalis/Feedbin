source "https://rubygems.org"
git_source(:github) { |name| "https://github.com/#{name}.git" }

gem "rails", "= 7.0.6"
ruby "3.2.2"
gem "will_paginate"

gem 'stripe'

gem "puma"

gem 'dalli'

gem "http",                github: "feedbin/http",                branch: "feedbin"
gem "carrierwave",         github: "feedbin/carrierwave",         branch: "feedbin"
gem "sax-machine",         github: "feedbin/sax-machine",         branch: "feedbin"
gem "feedjira",            github: "feedbin/feedjira",            branch: "f2"
gem "feedkit",             github: "feedbin/feedkit",             branch: "master"
gem "html-pipeline",       github: "feedbin/html-pipeline",       branch: "feedbin"
gem "html_diff",           github: "feedbin/html_diff",           ref: "013e1bb"
gem "twitter",             github: "feedbin/twitter",             branch: "feedbin"

# https://github.com/mikel/mail/issues/1521
gem "mail", "< 2.8"

gem "activerecord-import"
gem "addressable", require: "addressable/uri"

gem "apnotic"
gem "autoprefixer-rails"
gem "bcrypt"
gem "bootsnap", require: false
gem "clockwork"
gem "coffee-rails"
gem "connection_pool"
gem "dotenv-rails"
gem "down"
gem "evernote_oauth"
gem "fog-aws"
gem "honeybadger"
gem "htmlentities"
gem "httparty"
gem "image_processing"
gem "importmap-rails", "~> 1.1"
gem "jbuilder"
gem "jquery-rails"
gem "jwt"
gem "librato-rails", "~> 1.4.2"
gem "lograge"
gem "lookbook"
gem "net-http-persistent"
gem "oauth"
gem "oauth2"
gem "pg"
gem "phlex-rails"
gem "postmark-rails"
gem "premailer-rails"
gem "raindrops"
gem "redcarpet"
gem "redis", "< 5"
gem "responders"
gem "reverse_markdown"
gem "ruby-vips"
gem "rubyzip", require: "zip"
gem "sanitize"
gem "sass-rails"
gem "sidekiq", "= 6.5.7"
gem "stimulus-rails"
gem "strong_migrations"
gem "tailwindcss-rails"
gem "twitter-text"
gem "uglifier"
gem "unicorn"
gem "web-push"

group :development do
  gem "benchmark-ips"
  gem "better_errors"
  gem "binding_of_caller"
  gem "htmlbeautifier"
  gem "listen"
  gem "foreman"
  gem "pry"
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", github: "teamcapybara/capybara"
  gem "debug"
  gem "faker"
  gem "minitest"
  gem "minitest-stub-const"
  gem "minitest-stub_any_instance"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "standard"
  gem "webmock", "= 3.8.0"
end

