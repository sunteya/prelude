require "rails_helper"

RSpec.describe ClientsController do
  it_should_behave_like "a resources controller", except: [ :show ] do
    login_superadmin

    let(:client) { create :client }
    before { expect(client).to be_persisted }
    let(:resource) { client }
    let(:valid_attributes) { attributes_for(:client) }
    let(:invalid_attributes) { { hostname: "" } }
  end
end
