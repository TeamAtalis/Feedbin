require "sidekiq"
require ::File.expand_path("../../../lib/job_stat", __FILE__)

SIDEKIQ_ALT = ConnectionPool.new(size: 1, timeout: 2) { Redis.new(timeout: 1.0) }

Sidekiq.strict_args!(false)
Sidekiq::Extensions.enable_delay!

#Set up a Logger instance
sidekiq_logger = Logger.new(File.join(Rails.root, 'log', 'sidekiq.log'))
Sidekiq.logger = sidekiq_logger

Sidekiq.configure_server do |config|
  ActiveRecord::Base.establish_connection
  config.server_middleware do |chain|
    chain.add JobStat
  end
  config.redis = {id: "feedbin-server-#{::Process.pid}"}
end

Sidekiq.configure_client do |config|
  config.redis = {id: "feedbin-client-#{::Process.pid}"}
end
