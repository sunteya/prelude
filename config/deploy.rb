require "capsum/typical"

set :application, "prelude"
set :repository, ".git"
set(:bundle_dir) { File.join(fetch(:shared_path), 'bundle') }

set :shared, %w{
  config/mail.yml
  config/database.yml
}
