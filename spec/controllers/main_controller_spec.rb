require 'spec_helper'

RSpec.describe MainController, type: :controller do
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

  shared_examples "pac action" do
    let(:user) { create :user }

    context "without auth token" do
      it { should respond_with(:unauthorized) }
    end

    context "with auth token" do
      before { token_auth(user.authentication_token) }
      it { should respond_with(:success) }
    end
  end

  describe "GET whitelist" do
    it_should_behave_like "pac action" do
      action { get :whitelist, format: :pac }
    end
  end

  describe "GET blacklist" do
    it_should_behave_like "pac action" do
      action { get :blacklist, format: :pac }
    end
  end
end
