class MyBenchmark
  require 'benchmark/ips'
  #require "#{Rails.root}/test/support/login_helper"
  #require "#{Rails.root}/test/test_helper"

  # Desc: This method is used to benchmark the feedbin:update_profile
  #       rake task. This method will generate a report
  #       (admin_update_profile_rake_task.log) on /lib/benchmarks/reports.
  #
  # input parameters:
  #       @params[:feed_id] [int]: id of the Feed.
  #       @params[:user_id] [int]: id of User. This user will be
  #                                the admin who makes the update
  #
  def self.admin_update_profile_rake_task(feed_id, user_id)
    # Measure the rake task
    benchmark = Benchmark.measure { system("rake \"feedbin:update_profile[ #{feed_id}, #{user_id}]\"")}
    # Write Benchmark on log file
    file = File.open("#{Rails.root}/lib/benchmarks/reports/admin_update_profile_rake_task.log", 'a')
    file.puts("***-----------------------------------------------------***")
    file.puts("[Log created at #{Time.now}], [TOTAL USERS: #{User.all.size}], [TOTAL PROFILES: #{Profile.all.size}] ")
    file.puts("  USER_TIME  SYSTEM_TIME  TOTAL     (REAL)")
    file.puts(benchmark, "\n\n")
    file.close
  end

  def self.create_random_users(email, password)
    StripeMock.start
    plan = Plan.new(stripe_id: "trial", name: "Trial", price: 0, price_tier: 3)
    Stripe::Plan.create(name: plan.name, id: plan.stripe_id, amount: plan.price.to_i, currency: "USD", interval: "day")
    u = User.new(email: email, password: password, password_confirmation: "admin", admin: false)
    u.plan = plan
    u.update_auth_token = true
    u.save
    #Profile.find('1').assign_profile_to_user(u.id)
    StripeMock.stop
  end
end
