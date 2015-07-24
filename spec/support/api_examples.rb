RSpec.shared_context "require access token" do
  let(:current_client) { create :client }
  before { request.headers['X-Access-Token'] = current_client.access_token if current_client }

  context "without client access token" do
    let(:current_client) { nil }
    it { should respond_with(:unauthorized) }
  end
end