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

class DomainSet < ApplicationRecord
  enumerize :family, in: [ :blocked, :local, :lag ], scope: true

  validates :title, :content, presence: true

  def domains
    (content || "").split("\n").map do |line|
      line.sub(/#.*\z/, "").strip.presence
    end.compact
  end
end
