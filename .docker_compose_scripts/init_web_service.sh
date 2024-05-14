rails db:drop db:setup
# Front-End
rails assets:precompile
# Run server
rails s -b '0.0.0.0'