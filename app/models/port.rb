class Port
  include Mongoid::Document
  include Mongoid::Search

  has_many :rents
  
  field :number, :type => Integer
  field :rented, :type => Boolean, :default => false

end
