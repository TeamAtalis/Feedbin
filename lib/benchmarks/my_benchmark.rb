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
    benchmark = Benchmark.measure { system("rake \"feedbin:update_profile[ #{feed_id}, #{user_id}]\" ") }
    # Write Benchmark on log file
    file = File.open("#{Rails.root}/lib/benchmarks/reports/admin_update_profile_rake_task.log", 'a')
    file.puts("***-----------------------------------------------------***\n#{Time.now}")
    file.puts("  USER_TIME  SYSTEM_TIME  TOTAL     (REAL)")
    file.puts(benchmark, "\n\n")
    file.close
  end
end
