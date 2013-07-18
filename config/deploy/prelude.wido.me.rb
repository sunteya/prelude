set :deploy_to, "/var/www/wido.prelude/apps/#{application}"

set :rails_env, "production"
set :user, "www-data"
server "prelude.wido.me", :app, :web, :db, whenever: true, primary: true
