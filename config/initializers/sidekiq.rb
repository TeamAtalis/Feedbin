require "sidekiq"
require "connection_pool"
require "redis"

# Redis connection pool
SIDEKIQ_ALT = ConnectionPool.new(size: 1, timeout: 2) { Redis.new(url: 'redis://redis:6379/0') }

# Disable strict args check and enable delay extensions
Sidekiq.strict_args!(false)
Sidekiq::Extensions.enable_delay!

# Set up Sidekiq logger to log to STDOUT
Sidekiq.logger = Logger.new(STDOUT)

Sidekiq.configure_server do |config|
  # Establish ActiveRecord connection
  ActiveRecord::Base.establish_connection
  # Set Redis connection for server
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  # Set Redis connection for client
  config.redis = { url: 'redis://redis:6379/0' }
end
