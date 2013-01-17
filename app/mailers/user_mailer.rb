class UserMailer < Devise::Mailer
  helper :application
  
  def reset_password_email(user)
    @user = user
    @url  = "localhost:3000"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
  
  def reset_password_instructions(record, opts={})
    headers["to"] = record.email
    super
  end
end
