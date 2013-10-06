class BeerClub < ActiveRecord::Base
  attr_accessible :city, :founded, :name
  has_many :memberships
  has_many :users, :through => :memberships

  def to_s
    "#{name}" 
  end
end
