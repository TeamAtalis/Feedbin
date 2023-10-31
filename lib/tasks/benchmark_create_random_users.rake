namespace :benchmark do
    desc "Create random users"
    task :create_random_users, [:n_users_to_create] => :environment do |_, args|
        n_users_to_create = (args[:n_users_to_create]).to_i
        for i in 1..n_users_to_create
            email = "customer_#{i}@gmail.com"
            MyBenchmark.create_random_users(email, "admin")
        end
  end
end