class Port
  include Mongoid::Document
  include Mongoid::Search

  has_many :binds
  
  field :number, :type => Integer
  field :binded, :type => Boolean, :default => false
  
  search_in :number, :binded
  
  validates :number, :uniqueness => true

end
