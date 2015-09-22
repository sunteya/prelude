set :application, "prelude"

fetch(:linked_files).concat %w{
  config/mail.yml
  config/database.yml
  config/secrets.yml
  config/settings.local.rb
  tmp/restart.txt
}

fetch(:linked_dirs).concat %w{
  public/uploads
}
