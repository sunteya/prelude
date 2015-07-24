require "rails_helper"

RSpec.describe UsersController do
  it_should_behave_like "a resources controller" do
    login_superadmin

    let(:user) { create :user }
    before { expect(user).to be_persisted }
    let(:resource) { user }
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { { password: "123456", password_confirmation: "654321" } }
  end
end
