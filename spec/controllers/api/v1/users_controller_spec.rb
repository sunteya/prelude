require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET index" do
    include_context "require access token"

    let!(:users) { create_list :user, 3 }
    action { get :index, format: :json }
    it { should respond_with(:success) }
  end
end
