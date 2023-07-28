rake db:drop
redis-server &
sleep 1
rake db:setup
redis-cli shutdown
