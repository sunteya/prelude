module LoginHelper
  extend ActiveSupport::Concern

  # def basic_auth(username, password = nil)
  #   request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{username}:#{password}")
  # end

  def token_auth(token)
    request.env["HTTP_AUTHORIZATION"] = "Token #{token}"
  end

  module ClassMethods
    def login_superadmin
      let(:current_user) { create :superadmin }
      before { sign_in(current_user) }
    end
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :controller
end