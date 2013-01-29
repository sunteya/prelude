require "capsum/typical"

set :application, "prelude"
set :repository, ".git"

set :shared, %w{
  config/mongoid.yml
}
