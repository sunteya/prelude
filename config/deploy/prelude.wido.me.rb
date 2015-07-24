set :deploy_to, -> { "/var/www/wido.prelude/apps/#{fetch(:application)}" }
server "www-data@prelude.wido.me", roles: %w[web app db], whenever: true, primary: true
