set :deploy_to, "/var/www/wido.p/#{application}"

set :user, "www-data"
server "p.wido.me", :app, :web, :db

