require "rails_helper"

RSpec.describe DomainSetsController do
  it_should_behave_like "a resources controller", except: [ :show ] do
    login_superadmin

    let(:domain_set) { create :domain_set }
    before { expect(domain_set).to be_persisted }
    let(:resource) { domain_set }
    let(:valid_attributes) { attributes_for(:domain_set) }
    let(:invalid_attributes) { { title: "" } }
  end
end
