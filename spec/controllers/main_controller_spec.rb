require 'spec_helper'

describe MainController do
  describe "GET root" do
    action { get :root }

    context 'then not login' do
      it { should redirect_to(new_user_session_path) }
    end

    context 'then logined' do
      let(:current_user) { create :user }
      before { sign_in(current_user) }
      it { should redirect_to(user_path(current_user)) }
    end
  end
end
