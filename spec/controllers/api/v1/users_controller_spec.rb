require 'spec_helper'

describe Api::V1::UsersController do
  describe "GET index" do
    include_context "require access token"

    let!(:users) { create_list :user, 3 }
    action { get :index, format: :json }
    it { should respond_with(:success) }
  end
end
