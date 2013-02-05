require "capsum/typical"

set :application, "prelude"
set :repository, ".git"

set :shared, %w{
  allow
  pcaps
  config/mongoid.yml
}
