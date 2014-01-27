class UserMailer < Devise::Mailer
  helper :application
  
  def reset_password_instructions(record, opts={})
    headers["to"] = record.email
    super
  end
end
