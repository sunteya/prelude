set :deploy_to, -> { "/home/app" }
server "app@prelude.wido.me:11022", roles: %w[web app db], whenever: true, primary: true
