require "rails_helper"

RSpec.describe Api::V1::TrafficsController do
  describe "POST create" do
    include_context "require access token"

    let(:user) { create :user }
    let(:params) { Hash.new }
    let(:attributes) { Hash.new }
    action { post :create, { format: :json, user_id: user.id, traffic: attributes }.merge(params) }

    context 'user not found' do
      before { params[:user_id] = 1231231231 }
      it { should respond_with(:not_found) }
    end

    context "new traffic" do
      let(:attributes) { attributes_for :traffic, :immediate }
      it { expect(response.body).to eq "" }
      it { should respond_with(:created)
           expect(user.reload.transfer_using).to eq(attributes[:incoming_bytes] + attributes[:outgoing_bytes]) }
    end

    context "update exist traffic" do
      let(:traffic) { create :traffic, :immediate, user: user, client_id: current_client.id }
      let(:attributes) { { upcode: traffic.upcode, incoming_bytes: traffic.incoming_bytes + 10000 } }
      it { should respond_with(:created)
           expect(user.reload.transfer_using).to eq(traffic.total_transfer_bytes + 10000) }
    end

    context "invalid attributes" do
      before { expect_any_instance_of(Traffic).to receive(:save) { false } }
      it { should respond_with(:unprocessable_entity) }
    end
  end
end
