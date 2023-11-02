class MyBenchmark
  require 'benchmark/ips'

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
    log_benchmark(Time.now, "#{Rails.root}/lib/benchmarks/reports", 'reports', 'admin_update_profile_rake_task.log', benchmark)
  end

  def self.create_random_users(email, password)
    StripeMock.start
    plan = Plan.new(stripe_id: "trial", name: "Trial", price: 0, price_tier: 3)
    Stripe::Plan.create(name: plan.name, id: plan.stripe_id, amount: plan.price.to_i, currency: "USD", interval: "day")
    u = User.new(email: email, password: password, password_confirmation: "admin", admin: false)
    u.plan = plan
    u.update_auth_token = true
    u.save
    Profile.find(1).assign_profile_to_user(u.id) # First profile
    StripeMock.stop
  end

  private_class_method

  # Desc: This method is used to write the benchmark on
  #       on specific file and directory.
  #
  # input parameters:
  #       @params[:log_time] [Time]: time of log.
  #       @params[:reports_dir] [String]: directory where will be all reports.
  #       @params[:name_reports_dir] [String]: name of the directory.
  #       @params[:name_file] [String]: name of the log file.
  #       @params[:benchmark] [Benchmark]: benchmark of the log to write.
  #
  def self.log_benchmark(log_time, reports_dir, name_reports_dir, name_file, benchmark)
    # View if directoy exists
    unless File.directory?(reports_dir)
      FileUtils.mkdir_p(reports_dir)
    end
    # Write Benchmark on log file
    file = File.open("#{Rails.root}/lib/benchmarks/#{name_reports_dir}/#{name_file}", 'a')
    file.puts("***-----------------------------------------------------***")
    file.puts("[Log created at #{log_time}], [TOTAL USERS: #{User.all.size}], [TOTAL PROFILES: #{Profile.all.size}] ")
    file.puts("  USER_TIME  SYSTEM_TIME  TOTAL     (REAL)")
    file.puts(benchmark, "\n\n")
    file.close
  end
end
