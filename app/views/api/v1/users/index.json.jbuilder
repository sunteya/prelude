json.users @users do |user|
  json.(user, :id, :email, :lock_version, :transfer_remaining, :binding_port) 
end