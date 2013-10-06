class User < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :username

  has_many :ratings
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, :through => :memberships

  def to_s
    "#{username}" 
      
  end
end
