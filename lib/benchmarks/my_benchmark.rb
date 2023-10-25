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
    $stdout = File.new("#{Rails.root}/lib/benchmarks/reports/admin_update_profile_rake_task.log", 'a')
    $stdout.sync = true
    puts("***-----------------------------------------------------***\n#{Time.now}")
    Benchmark.ips do |x|
      x.report('admin_update_profile_rake_task') do
        system("rake \"feedbin:update_profile[ #{feed_id}, #{user_id}]\" ")
      end
    end
    puts("\n\n\n") # Add space between logs
  end
end
