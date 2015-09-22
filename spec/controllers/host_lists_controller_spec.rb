require "rails_helper"

RSpec.describe HostListsController do
  def self.it_should_success_with_format(format)
    context "with #{format}" do
      before { base_params[:format] = format }
      it { is_expected.to respond_with(:success) }
    end
  end

  let!(:domain_set_1) { create :domain_set, family: :blocked }
  let!(:domain_set_2) { create :domain_set, family: :local }
  let!(:domain_set_3) { create :domain_set, family: :lag }

  describe "GET show" do
    let(:base_params) { { format: :pac } }
    action { get :show, base_params.merge(id: host_list.to_param) }

    context 'blacklist' do
      let(:host_list) { create :host_list, policy: :black }

      it_should_success_with_format :pac
      it_should_success_with_format :txt
      it_should_success_with_format :sorl
    end

    context 'blacklist' do
      let(:host_list) { create :host_list, policy: :white }

      it_should_success_with_format :pac
      it_should_success_with_format :txt
      it_should_success_with_format :sorl
    end

    context 'speedlist' do
      let(:host_list) { create :host_list, policy: :speed }

      it_should_success_with_format :pac
      it_should_success_with_format :txt
      it_should_success_with_format :sorl
    end
  end
end
