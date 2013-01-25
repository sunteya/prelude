class Port
  include Mongoid::Document
  include Mongoid::Search

  has_many :binds
  
  field :number, :type => Integer
  field :binded, :type => Boolean, :default => false
  
  validates :number, :uniqueness => true

end
