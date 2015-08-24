# == Schema Information
#
# Table name: domain_sets
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string
#  family     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe DomainSet do
  describe "#domains" do
    subject { DomainSet.new content: content }
    let(:content) { "" }

    context 'domain pre line' do
      let(:content) { "
        google.com
        youtube.com
      " }

      its(:domains) { is_expected.to eq [ "google.com", "youtube.com" ] }
    end

    context 'ignore comment text' do
      let(:content) { "
        # Google
        youtube.com # youtube
      " }
      its(:domains) { is_expected.to eq [ "youtube.com" ] }
    end
  end
end
