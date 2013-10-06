class User < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :username

  has_many :ratings
  has_many :beers, :through => :ratings

  def to_s
    "#{username}" 
      
  end
end
