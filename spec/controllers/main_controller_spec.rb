require "rails_helper"

RSpec.describe MainController do
  describe "GET root" do
    action { get :root }

    context 'then not login' do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'then logined' do
      let(:current_user) { create :user }
      before { sign_in(current_user) }
      it { is_expected.to redirect_to(user_path(current_user)) }
    end
  end

  describe "GET whitelist" do
    let(:base_params) { Hash.new }
    let(:user) { create :user }
    action { get :whitelist, base_params.merge(format: :pac) }

    context "without auth token" do
      it { is_expected.to respond_with(:unauthorized) }
    end

    context "with auth token" do
      before { base_params[:auth_token] = user.authentication_token }
      it { is_expected.to respond_with(:moved_permanently) }
    end
  end

  describe "GET blacklist" do
    let(:base_params) { Hash.new }
    let(:user) { create :user }
    action { get :blacklist, base_params.merge(format: :pac) }

    context "without auth token" do
      it { is_expected.to respond_with(:unauthorized) }
    end

    context "with auth token" do
      before { base_params[:auth_token] = user.authentication_token }
      it { is_expected.to respond_with(:moved_permanently) }
    end
  end
end
