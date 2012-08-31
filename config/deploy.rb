require "capsum/typical"

set :application, "prelude"
set :repository, ".git"

set :shared, %w{
  allow
  config/secret.rb
}
